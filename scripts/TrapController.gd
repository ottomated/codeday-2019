extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var traps

var wall_trap_scene = preload("res://Wall_Trap.tscn")
var spike_trap_scene = preload("res://Spike_Trap.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	traps = {}
	
func initialize(traps):
	for trap in traps:
		add_trap(trap)
		
func add_trap(json):
	var trap
	match json["trap_type"]:
		"wall":
			trap = wall_trap_scene.instance()
		"spike":
			trap = spike_trap_scene.instance()
			trap.connect("body_entered", get_parent().get_node("PlayerController"), "test_local_player_overlap")
	traps[json["id"]] = trap
	add_child(trap)
	trap.initialize(json["position"])
	
func remove_trap(json):
	var trap = traps[json["id"]]
	trap.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
