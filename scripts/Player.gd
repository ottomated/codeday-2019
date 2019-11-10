extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal player_attack

var direction_indicator
var dash_hitbox
var dash_hitbox_shape

export var speed = 400
export var dash_distance = 250
export var dash_cooldown = 2.0
export var dash_stall = 0.3
export var damage = 10

var initial_position
var time_to_dash
var screen_size
var direction

# Called when the node enters the scene tree for the first time.
func _ready():
	time_to_dash = 0.0
	screen_size = get_viewport_rect().size
	direction_indicator = get_node("Direction Indicator")
	dash_hitbox = get_node("Dash Hitbox")
	dash_hitbox_shape = get_node("Dash Hitbox/Dash Hitbox Shape").get_shape()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(time_to_dash < dash_cooldown-dash_stall): # if player just dashed, stall for a second - makes dash feel more powerful
		var velocity = Vector2()  # The player's movement vector.
		if Input.is_action_pressed("ui_right"):
			velocity.x += 1
		if Input.is_action_pressed("ui_left"):
			velocity.x -= 1
		if Input.is_action_pressed("ui_down"):
			velocity.y += 1
		if Input.is_action_pressed("ui_up"):
			velocity.y -= 1
		velocity = velocity.normalized() * speed
		move_and_collide(velocity*delta, true)
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	if(time_to_dash == dash_cooldown):
		dash_followup()
	time_to_dash -= delta
	get_direction()
	
func _input(event):
	if event is InputEventMouseButton && time_to_dash <= 0:
		dash()
		
func get_direction():
	var mouse_position = get_viewport().get_mouse_position()
	direction = (mouse_position - position)
	direction_indicator.position = 5*sqrt(direction.length())*direction.normalized()
	direction = direction.normalized()
	
func dash():
	initial_position = position
	move_and_collide(dash_distance*direction, true)
	time_to_dash = dash_cooldown
	
func dash_followup():
	var distance_traveled = (position - initial_position).length()
	dash_hitbox.rotation = (position - initial_position).angle()
	var rectangle_dimensions = Vector2(distance_traveled, 60)
	dash_hitbox_shape.set_extents(rectangle_dimensions/2)
	dash_hitbox.position = -dash_hitbox_shape.get_extents().x*direction
	emit_signal("player_attack", dash_hitbox, damage)
	#hitbox is correct shape, size, and position here: add signaling
	