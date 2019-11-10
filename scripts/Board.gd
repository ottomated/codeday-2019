extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var ws

var player_controller
var trap_controller

# Called when the node enters the scene tree for the first time.
func _ready():
	ws = WebSocketClient.new()
	ws.connect("data_received", self, "packet")
	ws.connect_to_url("ws://192.168.2.43:8080")
	ws.get_peer(1).set_write_mode(WebSocketPeer.WRITE_MODE_TEXT)
	
	player_controller = get_node("PlayerController")
	trap_controller = get_node("TrapController")
	player_controller.ws = ws
	trap_controller.ws = ws
	
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
		"add_player":
			player_controller.add_player(json)
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	ws.poll()
