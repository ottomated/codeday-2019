extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var ws

var player_scene = preload("res://Player.tscn")

var players
var local_id

# Called when the node enters the scene tree for the first time.
func _ready():
	players = {}
	
func initialize(players):
	for player in players:
		add_player(player);

func add_player(json):
	var player = player_scene.instance()
	add_child(player)
	player.initialize(self, json["id"])
	players[json["id"]] = player
	player.health_bar.set_health(json["health"])
	var position_array = json["position"]
	player.position = Vector2(position_array[0], position_array[1])
	
func set_player_local(json):
	local_id = json["id"]
	players[local_id].declare_local()

func remove_player(json):
	var player = players[json["id"]]
	player.queue_free()
	
func update_player_pos(json):
	var player = players[json["id"]]
	var position_array = json["position"]
	player.position = Vector2(position_array[0], position_array[1])
	
func update_player_health(json):
	var player = players[json["d"]]
	var heal = json["health_up"] # if false, then player is being hurt
	if(heal):
		player.health_bar.heal()
	else:
		player.health_bar.hurt()
	
func player_dash(json):
	var player = players[json["id"]]
	var direction_array = json["direction"]
	player.direction = Vector2(direction_array[0], direction_array[1])
	player.dash()
	
func send_position(player):
	ws.get_peer(1).put_packet(JSON.print({"type": "player_move", "id": player.id, "position": [player.position.x, player.position.y]}).to_utf8())
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
