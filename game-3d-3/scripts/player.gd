extends CharacterBody3D


const SPEED = 55.0
const JUMP_VELOCITY = 40
var current_blend: float = 0.0
@onready var face: Node3D = $Stickman/Armature/Skeleton3D/BoneAttachment3D/Face
@onready var camera_3d: Camera3D = $Stickman/Armature/Skeleton3D/BoneAttachment3D/Face/Camera3D
@export var mouse_sensitivity: float = 0.002
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var bone_attachment_3d: BoneAttachment3D = $Stickman/Armature/Skeleton3D/BoneAttachment3D
@export var gravity_scale: float = 4.0 # Multiplicador de gravedad (caída rápida)

# Variables para el control de vista
var is_first_person: bool = true
# Definimos las posiciones
const FIRST_PERSON_POS = Vector3(0, 0, 0)
const THIRD_PERSON_POS = Vector3(0, 0.75, 15) # Un poco arriba y atrás

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	# ESTO HACE QUE GIRE EL CUERPO Y LA CARA
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		# Girar el cuerpo entero (Eje Y - Horizontal)
		rotate_y(-event.relative.x * mouse_sensitivity)
		
		# Girar solo la cara/cámara (Eje X - Vertical)
		face.rotate_x(-event.relative.y * mouse_sensitivity)
		
		# Limitar la rotación vertical para no dar la vuelta completa
		face.rotation.x = clamp(face.rotation.x, deg_to_rad(-80), deg_to_rad(80))
	
	# Cambiar de cámara con la tecla "C"
	if event.is_action_pressed("change_camera"): # Crear esta acción en Input Map
		toggle_camera()

func toggle_camera():
	is_first_person = !is_first_person
	
	if is_first_person:
		camera_3d.position = FIRST_PERSON_POS
	else:
		camera_3d.position = THIRD_PERSON_POS
		
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		var current_gravity = gravity_scale
		if velocity.y < 0: # Estamos cayendo
			current_gravity = gravity_scale * 10.5 # Cae un 50% más rápido
		
		velocity += get_gravity() * current_gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	# Obtienes un valor entre 0.0 (quieto) y 1.0 (corriendo a tope).
	var target_blend = velocity.length() / SPEED
	# lerp sirve para ir de un punto A a un punto B gradualmente.
	# El valor 0.1 hace que tarde un poco en empezar a hacer la animación de correr.
	current_blend = lerp(current_blend, target_blend, 0.1)
	# Aplicamos el valor SUAVIZADO al AnimationTree
	animation_tree.set("parameters/BlendSpace1D/blend_position", current_blend)
	move_and_slide()
