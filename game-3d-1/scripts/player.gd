extends CharacterBody3D


const SPEED = 30.0
const JUMP_VELOCITY = 6
const MOUSE_SENSITIVITY = 0.002 # Sensibilidad del mouse
@onready var camera_pivot: Node3D = $CameraPivot

func _ready():
	# Captura el mouse para que no se salga de la ventana
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _unhandled_input(event):
	# Si el mouse se mueve
	if event is InputEventMouseMotion:
		# Rotar el personaje de izquierda a derecha (Eje Y)
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		
		# Rotar el pivote de la cámara de arriba a abajo (Eje X)
		camera_pivot.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		
		# Limitar la rotación para no dar volteretas (clamping)
		camera_pivot.rotation.x = clamp(camera_pivot.rotation.x, deg_to_rad(-80), deg_to_rad(80))

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
