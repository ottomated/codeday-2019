extends StaticBody2D
var Maze = load("res://maze/maze.gd")

var maze_obj
var maze

export(float) var line_width = 0.5
export(int) var line_scale = 8

func get_pos(x, y, num):
	match num:
		1: return Vector2(x * line_scale, y * line_scale)
		2: return Vector2(x * line_scale + line_scale - line_width, y * line_scale)
		4: return Vector2(x * line_scale, y * line_scale + line_scale - line_width)
		8: return Vector2(x * line_scale, y * line_scale)
		
func get_c_pos(x, y, num):
	var p = get_pos(x, y, num)
	if num == 1 or num == 4:
		p.x += line_scale / 2
		p.y += line_width / 2
	else:
		p.y += line_scale / 2
		p.x += line_width / 2
	return p
			
func _ready():
	maze_obj = Maze.new(16, 8)
	maze = maze_obj.maze
	for x in range(maze_obj.width + 2):
		for y in range(maze_obj.height + 2):
			if maze[x][y].is_open(1):
				var p = CollisionShape2D.new()
				p.shape = RectangleShape2D.new()
				p.translate(get_c_pos(x, y, 1))
				p.shape.extents = Vector2(line_scale, line_width) / 2
				add_child(p)
			if maze[x][y].is_open(2):
				var p = CollisionShape2D.new()
				p.shape = RectangleShape2D.new()
				p.translate(get_c_pos(x, y, 2))
				p.shape.extents = Vector2(line_width, line_scale) / 2
				add_child(p)
			if maze[x][y].is_open(4):
				var p = CollisionShape2D.new()
				p.shape = RectangleShape2D.new()
				p.translate(get_c_pos(x, y, 4))
				p.shape.extents = Vector2(line_scale, line_width) / 2
				add_child(p)
			if maze[x][y].is_open(8):
				var p = CollisionShape2D.new()
				p.shape = RectangleShape2D.new()
				p.translate(get_c_pos(x, y, 8))
				p.shape.extents = Vector2(line_width, line_scale) / 2
				add_child(p)
	
func _draw():
	for x in range(maze_obj.width + 2):
		for y in range(maze_obj.height + 2):
			if maze[x][y].is_open(1):
				draw_rect(Rect2(get_pos(x, y, 1), Vector2(line_scale, line_width)), Color.black)
			if maze[x][y].is_open(2):
				draw_rect(Rect2(get_pos(x, y, 2), Vector2(line_width, line_scale)), Color.black)
			if maze[x][y].is_open(4):
				draw_rect(Rect2(get_pos(x, y, 4), Vector2(line_scale, line_width)), Color.black)
			if maze[x][y].is_open(8):
				draw_rect(Rect2(get_pos(x, y, 8), Vector2(line_width, line_scale)), Color.black)