extends KinematicBody2D
 
const MOVE_SPEED = 200

var id

var all_player_list = []
var near_player_list = []
 
func _ready():
	pass
	
 
func _physics_process(delta):
    var vec_to_player = get_target()
    vec_to_player = vec_to_player.normalized()
    global_rotation = atan2(vec_to_player.y, vec_to_player.x)
    move_and_collide(vec_to_player * MOVE_SPEED * delta)

func get_target():
	if(near_player_list.size() > 0):
		var target = near_player_list[0].position-position
		for player in near_player_list:
			var vec_to = player.position - position
			if vec_to.length() < target.length():
				target = vec_to
		return target
	else:
		return Vector2(0, 0)

func _on_Detection_Radius_body_entered(body):
	if body in all_player_list:
		near_player_list.append(body)
