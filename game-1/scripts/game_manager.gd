extends Node

@onready var score_label: Label = $ScoreLabel
var score = 0

func add_point():
	score += 1
	print(score)
	score_label.text = "Score: " + str(score)

# Only can be access from same Scene if GameManager is marked as "Unique Name"
