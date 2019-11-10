extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var ws

var player_controller
var trap_controller
var enemy_controller

var Maze = load("res://scripts/Maze.gd");

# Called when the node enters the scene tree for the first time.
func _ready():
	ws = WebSocketClient.new()
	ws.connect("data_received", self, "packet")
	ws.connect_to_url("ws://192.168.1.47:8080")
	ws.get_peer(1).set_write_mode(WebSocketPeer.WRITE_MODE_TEXT)
	
	player_controller = get_node("PlayerController")
	trap_controller = get_node("TrapController")
	enemy_controller = get_node("EnemyController")
	
	player_controller.ws = ws
	
func packet():
	var string = ws.get_peer(1).get_packet().get_string_from_utf8()
	var json = JSON.parse(string)
	if json.error != OK:
		return;
	json = json.result;
	match json["type"]:
		"initialize":
			player_controller.initialize(json["players"])
			trap_controller.initialize(json["traps"])
			enemy_controller.set_players(player_controller.players)
			var maze = Maze.new($TileMap, json["seed"]);
			ws.get_peer(1).put_packet(JSON.print({"type": "spawn_points", "points": maze.enemy_spawn_list}).to_utf8())
		"add_player":
			player_controller.add_player(json)
			enemy_controller.set_players(player_controller.players)
		"set_player_local":
			player_controller.set_player_local(json)
		"remove_player":
			player_controller.remove_player(json)
		"update_player_pos":
			player_controller.update_player_pos(json)
		"update_player_health":
			player_controller.update_player_health(json)
		"player_dash":
			player_controller.player_dash(json)
		"add_trap":
			trap_controller.add_trap(json)
		"remove_trap":
			trap_controller.remove_trap(json)
		"add_enemy":
			enemy_controller.add_enemy(json)
		"remove_enemy":
			enemy_controller.remove_enemy(json)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	ws.poll()
