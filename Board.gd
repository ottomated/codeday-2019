extends Node2D

var ws

func _ready():
	ws = WebSocketClient.new();
	ws.connect("data_received", self, "packet")
	ws.connect_to_url("ws://localhost:8080")
	
func packet():
	var string = ws.get_peer(1).get_packet().get_string_from_utf8();
	var json = JSON.parse(string);
	if json.error != OK:
		return;
	print(string);
	if json["type"] == "ready":
		var players = json["players"];
		for player in players:
			
	
func _process(delta):
	ws.poll();