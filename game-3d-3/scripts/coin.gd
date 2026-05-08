extends Area3D

const ROT_SPEED = 2
@onready var game_manager: Node = $"../GameManager"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	rotate_y(deg_to_rad(ROT_SPEED))


func _on_body_entered(body: Node3D) -> void:
	if body.name == "Player": 
		print("+1 coin.")
		game_manager.add_point()
		queue_free()
