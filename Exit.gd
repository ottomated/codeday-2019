extends StaticBody2D

var pos
# Called when the node enters the scene tree for the first time.
#func _ready():
#	position = get_node("Board").exit

func set_pos(x, tile_size):
	position = x * tile_size
	print(position)
	