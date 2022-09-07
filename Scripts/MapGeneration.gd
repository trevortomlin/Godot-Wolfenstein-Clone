extends GridMap

var map =  []
var width := 10
var height := 10

var num_rooms = 20

var room_width := 5
var room_height := 5

enum directions {N, S, W, E}

func spawn(x, y):
	#return Vector3(2 * room_width * x + room_width / 2, 1, 2 * room_height * y + room_height / 2)
	yield(get_tree().create_timer(.01), "timeout")
	Event.emit_signal("spawn_player", Vector3(2 * room_width * x, 5, 2 * room_height * y))
	
func _ready():
	
	seed(12)
	
	for x in range(width):
		map.append([])
		for y in range(height):
			map[x].append(0)
			
	var startpos = drunkard_walk()
	#update_gridmap()
	
	#spawn(startpos[0], startpos[1])
			
func drunkard_walk():
	
	var x = randi() % width
	var y = randi() % height
	
	var startx = x
	var starty = y
	
	var current_room_ct = 0
	
	while current_room_ct < num_rooms:
		
		var pos_valid = false
		var rand_dir = randi() % directions.size()
		while not pos_valid:
			
			if rand_dir == directions.N:
				pos_valid = _pos_valid(x, y+1)
			elif rand_dir == directions.S:
				pos_valid = _pos_valid(x, y-1)
			elif rand_dir == directions.E:
				pos_valid = _pos_valid(x+1, y)
			elif rand_dir == directions.W:
				pos_valid = _pos_valid(x-1, y)
			
			if pos_valid:
				break
			rand_dir = randi() % directions.size()
				
		if rand_dir == directions.N:
			y += 1
		elif rand_dir == directions.S:
			y -= 1
		elif rand_dir == directions.E:
			x += 1
		elif rand_dir == directions.W:
			x -= 1

		#var sizex = randi() % room_width
		#var sizey = randi() % room_height
		
		map[x][y] = 1

		current_room_ct += 1
	
	return [startx, starty]
	
func update_gridmap():
	self.clear()
	
	for x in range(width):
		for y in range(height):
			if map[x][y] == 1:
				place_room(x, y)
			else:
				fill_floor(x, y)
				
func place_room(x, y):
	for x1 in range(room_width*x, room_width*x + room_width):
		for y1 in range(room_height*y, room_height*y + room_height):
			#if x1 == room_width*x or x1 == room_width*x + room_width -1 or y1 == room_height*y or y == room_height*y+room_height :
			#	self.set_cell_item(x1, 0, y1, 0)
			#else:
			self.set_cell_item(x1, 0, y1, 1)
			
func fill_floor(x, y):
	for x1 in range(room_width*x, room_width*x + room_width):
		for y1 in range(room_height*y, room_height*y + room_height):
			self.set_cell_item(x1, 0, y1, 0)

func _pos_valid(x, y):
	return x < width - 1 and x > 0 and y < height - 1 and y > 0
