extends Sprite

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var health

# Called when the node enters the scene tree for the first time.
func _ready():
	set_health(3)
	pass # Replace with function body.

func heal():
	return set_health(health + 1)
	pass

func hurt():
	return set_health(health - 1)
	pass
	
func set_health(amount):
	health = amount
	for child in get_children():
		if amount > 0:
			child.visible = true
		else:
			child.visible = false
		amount -= 1
	var alive = health == 0
	return alive

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
