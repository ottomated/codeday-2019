extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func initialize(position_array):
	position = Vector2(position_array[0], position_array[1])

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
