extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var directionIndicator

export var speed = 400
export var dash_distance = 200
export var dash_cooldown = 2.0

var time_to_dash
var screen_size
var direction

# Called when the node enters the scene tree for the first time.
func _ready():
	time_to_dash = 0.0
	screen_size = get_viewport_rect().size
	directionIndicator = get_node("Direction Indicator")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	time_to_dash -= delta
	print(time_to_dash)
	get_direction()
	
func _input(event):
	if event is InputEventMouseButton && time_to_dash <= 0:
		dash()
		
func get_direction():
	var mouse_position = get_viewport().get_mouse_position()
	direction = (mouse_position - position)
	directionIndicator.position = 5*sqrt(direction.length())*direction.normalized()
	direction = direction.normalized()
	
	
func dash():
	move_and_collide(dash_distance*direction, true)
	time_to_dash = dash_cooldown
	pass