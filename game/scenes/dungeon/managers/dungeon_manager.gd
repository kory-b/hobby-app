extends Node
class_name DungeonManager

@export var world_size: Vector2i = Vector2i(500, 500) # The size of the dungeon in tiles.
@export var min_rooms: int = 5 # The minimum number of rooms to generate.
@export var max_rooms: int = 10 # The maximum number of rooms to generate.
@export var min_room_size: int = 25 # The minimum size (width and height) of a room.
@export var max_room_size: int = 30 # The maximum size (width and height) of a room.
@export var hallway_width: int = 5 # The width of the hallways.
@export var max_hall_length: int = 40 # max tiles per straight run
@export var dungeon_seed: int = 0 # The seed for the random number generator. A value of 0 means a random seed.

@export var player: CharacterBody2D
@export var ladder: Node2D

# --- TILEMAP CONFIGURATION ---
@onready var floor_layer: TileMapLayer = $"FloorLayer" # Reference to the Floor TileMapLayer.
@onready var wall_layer: TileMapLayer = $WallLayer # Reference to the Wall TileMapLayer.


# --- CONSTANTS ---
const FLOOR_SOURCE_ID = 0 # The source ID for floor tiles in your TileSet.
const WALL_SOURCE_ID = 3 # The source ID for wall tiles in your TileSet.
const FLOOR_ATLAS_COORDS = Vector2i(0, 0) # Atlas coordinates for the floor tile.
const WALL_ATLAS_COORDS = Vector2i(0, 0) # Atlas coordinates for the wall tile.

# --- PRIVATE VARIABLES ---
var _rng = RandomNumberGenerator.new() # The random number generator instance.
var _exit_pos: Vector2i
var dungeon_generator: Generator = ProceduralRoomGenerator.new()

var rooms: Array:
	get:
		return dungeon_generator.rooms

# --- GODOT LIFECYCLE METHODS ---
func _ready():
	init_dungeon()

# --- CORE GENERATION LOGIC ---
func init_dungeon():
	# Configure the generator with our settings
	if dungeon_generator is ProceduralRoomGenerator:
		var proc_gen = dungeon_generator as ProceduralRoomGenerator
		proc_gen.room_size = min_room_size # Use configurable room size
		proc_gen.num_rooms = _rng.randi_range(min_rooms, max_rooms) # Random number of rooms
		proc_gen.world_size = world_size
		proc_gen.dungeon_seed = dungeon_seed
	
	dungeon_generator.generate(floor_layer, wall_layer)
	print("Rooms:", dungeon_generator.rooms)
	print("Player Position: ", player.position)
	var player_spawn = dungeon_generator.player_spawn
	var exit_spawn = dungeon_generator.exit_spawn
	var rooms = dungeon_generator.rooms
	if dungeon_generator.rooms.size() > 0:
		var tile_size = floor_layer.tile_set.tile_size
		# Place ladder at exit spawn instead of offset from player
		ladder.position = floor_layer.map_to_local(exit_spawn) + tile_size / 2.0
		player.position = floor_layer.map_to_local(player_spawn) + tile_size / 2.0
	print("Player Position: ", player.position)
	print("Ladder Position: ", ladder.position)
