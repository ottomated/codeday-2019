extends KinematicBody2D
 
const MOVE_SPEED = 200
 
onready var raycast = $RayCast2D
var health = 1
var Player = null
 
func _ready():
    add_to_group("zombies")
 
func _physics_process(delta):
    if Player == null:
        return
    var vec_to_player = Player.global_position - global_position
    vec_to_player = vec_to_player.normalized()
    global_rotation = atan2(vec_to_player.y, vec_to_player.x)
    move_and_collide(vec_to_player * MOVE_SPEED * delta)
    if health==0: #zombie is dead if health is 0
		coll.kill()
   # if raycast.is_colliding():#unused
      #  var coll = raycast.get_collider()
        #if coll.name == "Player":
         #  coll.kill()

func kill():
    queue_free()
 
func set_player(p):
    Player = p