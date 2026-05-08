extends CharacterBody3D

var player: CharacterBody3D = null
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@export var speed = 3.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_parent().get_node("Player")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if player == null:
		return

	# 1. Decirle al agente dónde está el objetivo
	nav_agent.target_position = player.global_position
	
	# 2. Verificar si ya llegamos o si el mapa de navegación está listo
	if nav_agent.is_navigation_finished():
		print("Player reached.")
		return

	# 3. Calcular la dirección hacia el siguiente punto de la ruta
	var current_pos = global_position
	var next_path_pos = nav_agent.get_next_path_position()
	
	# 4. Calcular velocidad y mover
	var new_velocity = (next_path_pos - current_pos).normalized() * speed
	velocity = new_velocity
	move_and_slide()


func _on_area_3d_body_entered(body: Node3D) -> void:
	# Verificamos si lo que entró al área es el jugador
	if body == player:
		print("¡Te atrapó!")
		call_deferred("restart")

func restart():
	# Esta línea recarga la escena actual desde cero
	get_tree().reload_current_scene()
