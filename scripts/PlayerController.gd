extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var player_scene = preload("res://Player.tscn")

var players
var local_id

# Called when the node enters the scene tree for the first time.
func _ready():
	players = {}

func add_player(var json):
	var player = player_scene.instance()
	add_child(player)
	players[json["player_id"]] = player
	player.health_bar.set_health(json["player_health"])
	var position_array = json["player_pos"]
	player.position = Vector2(position_array[0], position_array[1])
	
func set_player_local(var json):
	local_id = json["player_id"]
	players[local_id].declare_local()

func remove_player(var json):
	var player = players[json["player_id"]]
	player.queue_free()
	
func update_player_pos(var json):
	var player = players[json["player_id"]]
	var position_array = json["player_pos"]
	player.position = Vector2(position_array[0], position_array[1])
	
func update_player_health(var json):
	var player = players[json["player_id"]]
	var heal = json["health_up"] # if false, then player is being hurt
	if(heal):
		player.health_bar.heal()
	else:
		player.health_bar.hurt()
	
func player_dash(var json):
	var player = players[json["player_id"]]
	var direction_array = json["player_direction"]
	player.direction = Vector2(direction_array[0], direction_array[1])
	player.dash()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
