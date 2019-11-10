extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var ws

var enemy_scene = preload("res://Enemy.tscn")

var enemies
var players

# Called when the node enters the scene tree for the first time.
func _ready():
	enemies = {}
	pass # Replace with function body.

func set_players(players):
	self.players = players
	for i in enemies:
		enemies[i].all_player_list = players

func add_enemy(json):
	var enemy = enemy_scene.instance()
	enemy.get_node("Damage Radius").connect("body_entered", get_parent().get_node("PlayerController"), "test_local_player_overlap")
	add_child(enemy)
	enemy.all_player_list = players.values()
	enemies[json["id"]] = enemy
	enemy.id = json["id"]
	var position_array = json["position"]
	enemy.position = Vector2(64*position_array[0]+32, 64*position_array[1]+32)
	
func remove_enemy(json):
	if(enemies.has(json["id"])):	
		enemies[json["id"]].queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
