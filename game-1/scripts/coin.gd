extends Area2D

@onready var game_manager: Node = %GameManager
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#print("I am a coin.")
	pass


func _on_body_entered(body: Node2D) -> void:
	print("+1 coin.")
	game_manager.add_point()
	animation_player.play("pickup")
