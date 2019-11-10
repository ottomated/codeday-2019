extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var ws

var wall_trap_scene = preload("res://Wall_Trap.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func initialize(traps):
	for trap in traps:
		add_trap(trap)
		
func add_trap(json):
	var trap
	match json["trap_type"]:
		"wall":
			trap = wall_trap_scene.instance()
		"spike":
			pass
	add_child(trap)
	trap.initialize(json["position"]. json["rotation"])

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
