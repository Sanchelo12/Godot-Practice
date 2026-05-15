extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@onready var animation_tree : AnimationTree = $AnimationTree
@onready var state_machine = animation_tree["parameters/playback"]

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
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
	actualizar_animaciones(direction)
	
func actualizar_animaciones(direction: Vector3):
	# Verificar si el personaje se está moviendo en el suelo
	var esta_moviendose = direction.length() > 0
	
	# Cambiar las condiciones (las rutas deben coincidir EXACTAMENTE con los nombres en tu AnimationTree)
	if esta_moviendose:
		animation_tree.set("parameters/conditions/is_moving", true)
		animation_tree.set("parameters/conditions/idle", false)
	else:
		animation_tree.set("parameters/conditions/is_moving", false)
		animation_tree.set("parameters/conditions/idle", true)
	
	# 3. Detectar la acción de rodar (Tecla Q)
	# Nota: Tienes que ir a Ajustes del Proyecto -> Mapa de Entradas y crear la acción "roll" asignada a la tecla Q
	if Input.is_action_just_pressed("roll"):
		animation_tree.set("parameters/conditions/roll", true)
	else:
		# Es importante apagar la condición inmediatamente para que no se quede en un bucle infinito de roll
		animation_tree.set("parameters/conditions/roll", false)
