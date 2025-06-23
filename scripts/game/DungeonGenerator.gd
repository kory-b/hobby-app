# DungeonGenerator.gd
extends Node2D

# --- EXPORTED VARIABLES ---
# These variables can be configured from the Inspector in the Godot editor.

@export var world_size: Vector2i = Vector2i(500, 500) # The size of the dungeon in tiles.
@export var min_rooms: int = 5 # The minimum number of rooms to generate.
@export var max_rooms: int = 10 # The maximum number of rooms to generate.
@export var min_room_size: int = 25 # The minimum size (width and height) of a room.
@export var max_room_size: int = 30 # The maximum size (width and height) of a room.
@export var hallway_width: int = 5 # The width of the hallways.
@export var seed: int = 0 # The seed for the random number generator. A value of 0 means a random seed.

# --- TILEMAP CONFIGURATION ---
@onready var floor_layer: TileMapLayer = $"Background/FloorLayer" # Reference to the Floor TileMapLayer.
@onready var wall_layer: TileMapLayer = $Background/WallLayer # Reference to the Wall TileMapLayer.
@onready var player: CharacterBody2D = $Player

# --- CONSTANTS ---
const FLOOR_SOURCE_ID = 0 # The source ID for floor tiles in your TileSet.
const WALL_SOURCE_ID = 3 # The source ID for wall tiles in your TileSet.
const FLOOR_ATLAS_COORDS = Vector2i(0, 0) # Atlas coordinates for the floor tile.
const WALL_ATLAS_COORDS = Vector2i(0, 0) # Atlas coordinates for the wall tile.

# --- PRIVATE VARIABLES ---
var _rng = RandomNumberGenerator.new() # The random number generator instance.
var _rooms = [] # An array to store the generated rooms (as Rect2i).
var _player_spawn_pos: Vector2i
var _exit_pos: Vector2i

# --- GODOT LIFECYCLE METHODS ---

func _ready():
	"""
	Called when the node enters the scene tree for the first time.
	This is where we kick off the dungeon generation process.
	"""
	generate_dungeon()
	print("Rooms:", _rooms)
	print("Player Position: ", $Player.position)
	#$Player.position = _player_spawn_pos
	if _rooms.size() > 0:
		var tile_size = floor_layer.tile_set.tile_size
		player.position = floor_layer.map_to_local(_player_spawn_pos) + tile_size / 2.0
	print("Player Position: ", $Player.position)

# --- CORE GENERATION LOGIC ---

func generate_dungeon():
	"""
	The main function that orchestrates the entire dungeon generation process.
	"""
	# 1. Initialize the Random Number Generator
	if seed == 0:
		_rng.randomize() # Use a random seed if seed is 0.
	else:
		_rng.seed = seed # Use the specified seed for deterministic generation.

	# 2. Clear previous generation data
	_rooms.clear()
	floor_layer.clear()
	wall_layer.clear()

	# 3. Fill the entire map with walls
	for x in range(world_size.x):
		for y in range(world_size.y):
			wall_layer.set_cell(Vector2i(x,y), WALL_SOURCE_ID, WALL_ATLAS_COORDS)

	# 4. Generate rooms
	var room_count = _rng.randi_range(min_rooms, max_rooms)
	for i in range(room_count):
		var room_size = Vector2i(_rng.randi_range(min_room_size, max_room_size), _rng.randi_range(min_room_size, max_room_size))
		var room_position = Vector2i(_rng.randi_range(1, world_size.x - room_size.x - 1), _rng.randi_range(1, world_size.y - room_size.y - 1))
		var new_room = Rect2i(room_position, room_size)

		# Check for overlaps with existing rooms
		var overlaps = false
		for room in _rooms:
			# Add padding to intersection check to keep rooms separate
			if new_room.grow(2).intersects(room):
				overlaps = true
				break
		
		if not overlaps:
			_rooms.append(new_room)
			_carve_floor_rect(new_room)

	# 5. Connect the rooms with hallways
	# Sort rooms by position to create a more logical path
	_rooms.sort_custom(func(a, b): return a.position.x < b.position.x)
	for i in range(1, _rooms.size()):
		var prev_room_center = _rooms[i-1].get_center()
		var current_room_center = _rooms[i].get_center()
		_carve_hallway(prev_room_center, current_room_center)

	# 6. Set player spawn and exit locations
	if _rooms.size() > 0:
		_player_spawn_pos = _rooms[0].get_center()
		_exit_pos = _rooms[-1].get_center()
		
		print("Player Spawn:", _player_spawn_pos)
		print("Exit:", _exit_pos)
		
func _carve_floor_rect(rect: Rect2i):
	"""
	Places floor tiles in a given rectangular area on the floor_layer.
	"""
	for x in range(rect.position.x, rect.position.x + rect.size.x):
		for y in range(rect.position.y, rect.position.y + rect.size.y):
			setFloorTile(Vector2i(x, y))

func _carve_hallway(start: Vector2i, end: Vector2i):
	"""
	Carves a wide L-shaped hallway between two points.
	It carves a horizontal rectangle and a vertical rectangle.
	"""
	var half_width_floor = floor(hallway_width / 2.0)
	
	# Horizontal segment
	var h_rect_pos = Vector2i(min(start.x, end.x), start.y - half_width_floor)
	var h_rect_size = Vector2i(abs(start.x - end.x) + 1, hallway_width)
	_carve_floor_rect(Rect2i(h_rect_pos, h_rect_size))
	
	# Vertical segment
	var v_rect_pos = Vector2i(end.x - half_width_floor, min(start.y, end.y))
	var v_rect_size = Vector2i(hallway_width, abs(start.y - end.y) + 1)
	_carve_floor_rect(Rect2i(v_rect_pos, v_rect_size))

func setFloorTile(position: Vector2i):
	wall_layer.erase_cell(position)
	floor_layer.set_cell(position, FLOOR_SOURCE_ID, FLOOR_ATLAS_COORDS)
