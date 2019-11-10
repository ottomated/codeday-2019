extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var ws

var enemy_scene = preload("res://Player.tscn")

var enemies
var players

# Called when the node enters the scene tree for the first time.
func _ready():
	enemies = {}
	pass # Replace with function body.

func set_players(players):
	self.players = players
	for enemy in enemies:
		enemy.all_player_list = players

func add_enemy(json):
	var enemy = enemy_scene.instance()
	add_child(enemy)
	enemy.all_player_list = players
	enemies[json["id"]] = enemy
	var position_array = json["position"]
	enemy.position = Vector2(position_array[0], position_array[1])
	
func remove_enemy(json):
	enemies[json["id"]].queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
