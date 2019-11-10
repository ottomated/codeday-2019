extends Node2D

const N = 1
const E = 2
const S = 4
const W = 8

var cell_walls = {Vector2(0, -2): N, Vector2(2, 0): E, 
				  Vector2(0, 2): S, Vector2(-2, 0): W}

var tile_size = 64  # tile size (in pixels)
var width = 50 + randi() % 50  # width of map (in tiles)
var height = 50 + randi() % 50  # height of map (in tiles)

var map_seed = randi()

# fraction of walls to remove
var erase_fraction = 0.2

# Fraction that are rooms
var room_fraction = 0.1

# get a reference to the map for convenience
onready var Map = $TileMap

func _ready():
	$Camera2D.zoom = Vector2(2, 3)
	$Camera2D.position = Map.map_to_world(Vector2(width/2, height/2))
	randomize()
	if !map_seed:
		map_seed = randi()
	seed(map_seed)
	print("Seed: ", map_seed)
	tile_size = Map.cell_size
	make_maze()
	#erase_walls()
	create_rooms()
	
func check_neighbors(cell, unvisited):
	# returns an array of cell's unvisited neighbors
	var list = []
	for n in cell_walls.keys():
		if cell + n in unvisited:
			list.append(cell + n)
	return list
	
func make_maze():
	var unvisited = []  # array of unvisited tiles
	var stack = []
	# fill the map with solid tiles
	Map.clear()
	for x in range(width):
		for y in range(height):
			Map.set_cellv(Vector2(x, y), N|E|S|W)
	for x in range(0, width, 2):
		for y in range(0, height, 2):
			unvisited.append(Vector2(x, y))
	var current = Vector2(0, 0)
	unvisited.erase(current)
	# execute recursive backtracker algorithm
	while unvisited:
		var neighbors = check_neighbors(current, unvisited)
		if neighbors.size() > 0:
			var next = neighbors[randi() % neighbors.size()]
			stack.append(current)
			# remove walls from *both* cells
			var dir = next - current
			var current_walls = Map.get_cellv(current) - cell_walls[dir]
			var next_walls = Map.get_cellv(next) - cell_walls[-dir]
			Map.set_cellv(current, current_walls)
			Map.set_cellv(next, next_walls)
			# insert intermediate cell
			if dir.x != 0:
				Map.set_cellv(current + dir/2, 5)
			else:
				Map.set_cellv(current + dir/2, 10)
			current = next
			unvisited.erase(current)
		elif stack:
			current = stack.pop_back()
		# yield(get_tree(), 'idle_frame')

func erase_walls():
	# randomly remove a number of the map's walls
	for i in range(int(width * height * erase_fraction)):
		var x = int(rand_range(2, width/2 - 2)) * 2
		var y = int(rand_range(2, height/2 - 2)) * 2
		var cell = Vector2(x, y)
		# pick random neighbor
		var neighbor = cell_walls.keys()[randi() % cell_walls.size()]
		# if there's a wall between them, remove it
		if Map.get_cellv(cell) & cell_walls[neighbor]:
			var walls = Map.get_cellv(cell) - cell_walls[neighbor]
			var n_walls = Map.get_cellv(cell+neighbor) - cell_walls[-neighbor]
			Map.set_cellv(cell, walls)
			Map.set_cellv(cell+neighbor, n_walls)
			# insert intermediate cell
			if neighbor.x != 0:
				Map.set_cellv(cell+neighbor/2, 5)
			else:
				Map.set_cellv(cell+neighbor/2, 10)
			#yield(get_tree(), 'idle_frame')
		
func create_rooms():
	for w in range(2, int(width) - 1):
		for h in range(2, int(height) - 1):
			# check if open tile
			var cell = Vector2(w, h)
			if Map.get_cellv(cell) != 15 and int(rand_range(0,  10)) == 1:
				Map.set_cellv(cell, 0)
				#adjust surrounding tiles
				# above
				Map.set_cellv(Vector2(w, h - 1), convert_to_pos(w, h - 1, 1))
				#right above
				Map.set_cellv(Vector2(w + 1, h - 1), convert_to_pos(w + 1, h - 1, 3))
				#right
				Map.set_cellv(Vector2(w + 1, h), convert_to_pos(w + 1, h, 2))
				#right below
				Map.set_cellv(Vector2(w + 1, h + 1), convert_to_pos(w + 1, h + 1, 6))
				#below
				Map.set_cellv(Vector2(w, h + 1), convert_to_pos(w, h + 1, 4))
				#left below
				Map.set_cellv(Vector2(w - 1, h + 1), convert_to_pos(w - 1, h + 1, 12))
				#left
				Map.set_cellv(Vector2(w - 1, h), convert_to_pos(w - 1, h, 8))
				#left above
				Map.set_cellv(Vector2(w - 1, h - 1), convert_to_pos(w - 1, h - 1, 9))

func convert_to_array(n):
	var array = []
	for i in range(4):
		if n % int(pow(2, i + 1)) >= pow(2, i):
			array.append(1)
		else:
			array.append(0)
	return array

func convert_to_pos(x, y, n):
	var l = convert_to_array(Map.get_cellv(Vector2(x, y)))
	var a = convert_to_array(n)[0]
	var b = convert_to_array(n)[1]
	var c = convert_to_array(n)[2]
	var d = convert_to_array(n)[3]
	d = min(d, l[3])
	c = min(c, l[2])
	b = min(b, l[1])
	a = min(a, l[0])
	var sum = 8*d + 4*c + 2*b + a
	return sum