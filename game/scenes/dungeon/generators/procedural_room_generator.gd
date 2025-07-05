class_name ProceduralRoomGenerator extends Generator

# Configuration properties
@export var room_size: int = 25 # Size of each room (configurable)
@export var num_rooms: int = 8 # Number of rooms to generate (configurable)
@export var world_size: Vector2i = Vector2i(500, 500) # World bounds
@export var dungeon_seed: int = 0 # Seed for reproducible generation

# Tile constants for different wall types
const FLOOR_SOURCE_ID = 0
const WALL_SOURCE_ID = 1
const FLOOR_ATLAS_COORDS = Vector2i(0, 0)

# Different wall tile coordinates for variety
const TOP_WALL_ATLAS_COORDS = Vector2i(23,2) # Top wall tile
const BOTTOM_WALL_ATLAS_COORDS =  Vector2i(23, 0)# Bottom wall tile
const LEFT_WALL_ATLAS_COORDS = Vector2i(24, 1) # Left wall tile
const RIGHT_WALL_ATLAS_COORDS = Vector2i(22, 1) # Right wall tile
const CORNER_WALL_ATLAS_COORDS = Vector2i(22, 0) # Corner/default wall tile
const CENTER_ATLAS_COORDS = Vector2i(23, 1) # Corner/default wall tile

# Private variables
var _rng = RandomNumberGenerator.new()
var _room_positions: Array[Vector2i] = []
var _room_connections: Array[Array] = []

func generate(floor_layer: TileMapLayer, wall_layer: TileMapLayer) -> void:
	print("ProceduralRoomGenerator: Starting generation")
	
	# Initialize RNG
	if dungeon_seed == 0:
		_rng.randomize()
	else:
		_rng.seed = dungeon_seed
	
	# Clear previous data
	rooms.clear()
	_room_positions.clear()
	_room_connections.clear()
	floor_layer.clear()
	wall_layer.clear()
	
	# Generate the dungeon
	_generate_room_layout()
	_resolve_room_collisions()
	_generate_room_connections()
	_generate_tile_data(floor_layer, wall_layer)
	_set_spawn_points()
	
	print("ProceduralRoomGenerator: Generation complete")
	print("Generated rooms: ", rooms.size())
	print("Player spawn: ", player_spawn)
	print("Exit spawn: ", exit_spawn)

func _generate_room_layout() -> void:
	"""Generate initial room positions using procedural placement"""
	
	# Start with first room at a reasonable position
	var first_room_pos = Vector2i(
		world_size.x / 4,
		world_size.y / 4
	)
	_room_positions.append(first_room_pos)
	
	# Generate remaining rooms
	for i in range(1, num_rooms):
		var new_room_pos = _find_next_room_position()
		if new_room_pos != Vector2i(-1, -1): # Valid position found
			_room_positions.append(new_room_pos)

func _find_next_room_position() -> Vector2i:
	"""Find a valid position for the next room"""
	var attempts = 0
	var max_attempts = 100
	
	while attempts < max_attempts:
		# Choose a random existing room to branch from
		var base_room_idx = _rng.randi() % _room_positions.size()
		var base_room_pos = _room_positions[base_room_idx]
		
		# Choose a random direction (up, down, left, right, or diagonal)
		var directions = [
			Vector2i(1, 0), # Right
			Vector2i(-1, 0), # Left
			Vector2i(0, 1), # Down
			Vector2i(0, -1), # Up
			Vector2i(1, 1), # Down-right
			Vector2i(-1, 1), # Down-left
			Vector2i(1, -1), # Up-right
			Vector2i(-1, -1) # Up-left
		]
		
		var direction = directions[_rng.randi() % directions.size()]
		
		# Calculate distance (1-3 room sizes apart)
		var distance = _rng.randi_range(1, 3) * (room_size + 5) # +5 for spacing
		var new_pos = base_room_pos + direction * distance
		
		# Check if position is valid (within bounds and not overlapping)
		if _is_valid_room_position(new_pos):
			return new_pos
		
		attempts += 1
	
	# If no valid position found, return invalid marker
	return Vector2i(-1, -1)

func _is_valid_room_position(pos: Vector2i) -> bool:
	"""Check if a room position is valid (within bounds and not overlapping)"""
	
	# Check world bounds
	if pos.x < 10 or pos.y < 10:
		return false
	if pos.x + room_size >= world_size.x - 10:
		return false
	if pos.y + room_size >= world_size.y - 10:
		return false
	
	# Check for overlaps with existing rooms
	var new_room_rect = Rect2i(pos, Vector2i(room_size, room_size))
	for existing_pos in _room_positions:
		var existing_rect = Rect2i(existing_pos, Vector2i(room_size, room_size))
		# Add padding to prevent rooms from being too close
		if new_room_rect.grow(8).intersects(existing_rect):
			return false
	
	return true

func _resolve_room_collisions() -> void:
	"""Resolve any remaining collisions between rooms"""
	# For this implementation, we rely on the collision detection in _is_valid_room_position
	# More sophisticated collision resolution could be added here if needed
	pass

func _generate_room_connections() -> void:
	"""Generate connections between rooms for pathfinding"""
	_room_connections.clear()
	
	# Create a simple connection pattern - each room connects to the next
	for i in range(_room_positions.size() - 1):
		_room_connections.append([i, i + 1])
	
	# Add some additional connections for more interesting layouts
	if _room_positions.size() > 3:
		# Connect first and last room occasionally
		if _rng.randf() < 0.3:
			_room_connections.append([0, _room_positions.size() - 1])
		
		# Add some random connections
		var extra_connections = _rng.randi_range(0, 2)
		for i in range(extra_connections):
			var room1 = _rng.randi() % _room_positions.size()
			var room2 = _rng.randi() % _room_positions.size()
			if room1 != room2:
				_room_connections.append([room1, room2])

func _generate_tile_data(floor_layer: TileMapLayer, wall_layer: TileMapLayer) -> void:
	"""Generate the actual tile data for rooms and corridors"""
	
	# First, fill the world with walls
	for x in range(world_size.x):
		for y in range(world_size.y):
			wall_layer.set_cell(Vector2i(x, y), WALL_SOURCE_ID, CENTER_ATLAS_COORDS)
	
	# Generate rooms
	for i in range(_room_positions.size()):
		var room_pos = _room_positions[i]
		var room_rect = Rect2i(room_pos, Vector2i(room_size, room_size))
		rooms.append(room_rect)
		_carve_room(room_rect, floor_layer, wall_layer)
	
	# Generate corridors between connected rooms
	for connection in _room_connections:
		var room1_center = _room_positions[connection[0]] + Vector2i(room_size / 2, room_size / 2)
		var room2_center = _room_positions[connection[1]] + Vector2i(room_size / 2, room_size / 2)
		_carve_corridor(room1_center, room2_center, floor_layer, wall_layer)

func _carve_room(room_rect: Rect2i, floor_layer: TileMapLayer, wall_layer: TileMapLayer) -> void:
	"""Carve out a room with different wall types for each side"""
	
	# Carve floor area
	for x in range(room_rect.position.x + 1, room_rect.position.x + room_rect.size.x - 1):
		for y in range(room_rect.position.y + 1, room_rect.position.y + room_rect.size.y - 1):
			wall_layer.erase_cell(Vector2i(x, y))
			floor_layer.set_cell(Vector2i(x, y), FLOOR_SOURCE_ID, FLOOR_ATLAS_COORDS)
	
	# Create walls with different tiles for each side
	var start_x = room_rect.position.x
	var end_x = room_rect.position.x + room_rect.size.x - 1
	var start_y = room_rect.position.y
	var end_y = room_rect.position.y + room_rect.size.y - 1
	
	# Top wall
	for x in range(start_x+1, end_x):
		wall_layer.set_cell(Vector2i(x, start_y), WALL_SOURCE_ID, TOP_WALL_ATLAS_COORDS)
	
	# Bottom wall
	for x in range(start_x+1, end_x):
		wall_layer.set_cell(Vector2i(x, end_y), WALL_SOURCE_ID, BOTTOM_WALL_ATLAS_COORDS)
	
	# Left wall
	for y in range(start_y+1, end_y):
		wall_layer.set_cell(Vector2i(start_x, y), WALL_SOURCE_ID, LEFT_WALL_ATLAS_COORDS)
	
	# Right wall
	for y in range(start_y+1, end_y):
		wall_layer.set_cell(Vector2i(end_x, y), WALL_SOURCE_ID, RIGHT_WALL_ATLAS_COORDS)
	
	# Draw corners. These look goofy right now though. need to update the artwork. 
	#wall_layer.set_cell(Vector2i(start_x, start_y), WALL_SOURCE_ID, CORNER_WALL_ATLAS_COORDS)
	#wall_layer.set_cell(Vector2i(start_x, end_y), WALL_SOURCE_ID, CORNER_WALL_ATLAS_COORDS)
	#wall_layer.set_cell(Vector2i(end_x, start_y), WALL_SOURCE_ID, CORNER_WALL_ATLAS_COORDS)
	#wall_layer.set_cell(Vector2i(end_x, end_y), WALL_SOURCE_ID, CORNER_WALL_ATLAS_COORDS)

func _carve_corridor(start: Vector2i, end: Vector2i, floor_layer: TileMapLayer, wall_layer: TileMapLayer) -> void:
	"""Carve a corridor between two points"""
	var current = start
	var corridor_width = 3
	var half_width = corridor_width / 2
	
	# Carve horizontal path
	while current.x != end.x:
		var step = 1 if end.x > current.x else -1
		current.x += step
		
		# Carve corridor tiles
		for dy in range(-half_width, half_width + 1):
			var pos = Vector2i(current.x, current.y + dy)
			wall_layer.erase_cell(pos)
			floor_layer.set_cell(pos, FLOOR_SOURCE_ID, FLOOR_ATLAS_COORDS)
	
	# Carve vertical path
	while current.y != end.y:
		var step = 1 if end.y > current.y else -1
		current.y += step
		
		# Carve corridor tiles
		for dx in range(-half_width, half_width + 1):
			var pos = Vector2i(current.x + dx, current.y)
			wall_layer.erase_cell(pos)
			floor_layer.set_cell(pos, FLOOR_SOURCE_ID, FLOOR_ATLAS_COORDS)

func _set_spawn_points() -> void:
	"""Set player spawn and exit positions"""
	if rooms.size() > 0:
		# Player spawn in center of first room
		player_spawn = rooms[0].get_center()
		
		# Exit in center of last room
		exit_spawn = rooms[-1].get_center()

func get_player_spawn() -> Vector2i:
	return player_spawn
