extends Node

@onready var score_label: Label = $ScoreLabel
@onready var victory_menu: Control = $"../CanvasLayer/Control"
var score = 0

func _ready():
	# CADA VEZ QUE INICIA LA ESCENA:
	# Ponemos el ratón invisible y atrapado de nuevo
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	victory_menu.get_node("RestartButton").pressed.connect(_on_restart_pressed)
	victory_menu.get_node("ExitButton").pressed.connect(_on_exit_pressed)
	
func add_point():
	score += 1
	print(score)
	score_label.text = "Score: " + str(score)
	if(score == 3):
		show_victory_screen()

func show_victory_screen():
	victory_menu.show() # Mostrar menú
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) # Liberar el ratón
	get_tree().paused = true

func _on_restart_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_exit_pressed():
	get_tree().quit() # Cerrar juego
