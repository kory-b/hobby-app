extends Node2D

# How many enemies per room (you can tweak these in the Inspector)
@export var min_enemies_per_room: int = 1
@export var max_enemies_per_room: int = 3
@export var enemy_scene: PackedScene = preload("res://game/entities/enemies/enemy/enemy.tscn")

# A node to hold all spawned enemies
@onready var enemies_root: Node2D = get_node("Enemies")

@export var world_size: Vector2i = Vector2i(500, 500) # The size of the dungeon in tiles.
@export var min_rooms: int = 5 # The minimum number of rooms to generate.
@export var max_rooms: int = 10 # The maximum number of rooms to generate.
@export var min_room_size: int = 25 # The minimum size (width and height) of a room.
@export var max_room_size: int = 30 # The maximum size (width and height) of a room.
@export var hallway_width: int = 5 # The width of the hallways.
@export var max_hall_length: int = 40  # max tiles per straight run
@export var dungeon_seed: int = 0 # The seed for the random number generator. A value of 0 means a random seed.

# --- TILEMAP CONFIGURATION ---
@onready var floor_layer: TileMapLayer = $"Background/FloorLayer" # Reference to the Floor TileMapLayer.
@onready var wall_layer: TileMapLayer = $Background/WallLayer # Reference to the Wall TileMapLayer.
@onready var player: CharacterBody2D = $Player

# --- PRIVATE VARIABLES ---
var _rng = RandomNumberGenerator.new() # The random number generator instance.
var _rooms = [] # An array to store the generated rooms (as Rect2i).
var _player_spawn_pos: Vector2i
var _exit_pos: Vector2i

var fireball_scene = preload("res://game/entities/fireball/fireball.tscn")

var attack_cooldown = .5
var last_attack = 0

# --- GODOT LIFECYCLE METHODS ---

func _ready():
	spawn_enemies()
	print("Rooms:", _rooms)
	print("Player Position: ", $Player.position)
	#$Player.position = _player_spawn_pos
	if _rooms.size() > 0:
		var tile_size = floor_layer.tile_set.tile_size
		player.position = floor_layer.map_to_local(_player_spawn_pos) + tile_size / 2.0
	print("Player Position: ", $Player.position)

func spawn_enemies():
	pass
	#var tile_size = floor_layer.tile_set.tile_size
	#for room in _rooms:
		#var count = _rng.randi_range(min_enemies_per_room, max_enemies_per_room)
		#for i in range(count):
			#var cell = Vector2i(
				#_rng.randi_range(room.position.x, room.position.x + room.size.x - 1),
				#_rng.randi_range(room.position.y, room.position.y + room.size.y - 1)
			#)
			#if floor_layer.get_cell_source_id(cell) != FLOOR_SOURCE_ID:
				#continue
#
			#var enemy = enemy_scene.instantiate() as Enemy
#
			#var local_pos = floor_layer.map_to_local(cell)
			#var world_pos = floor_layer.to_global(local_pos) + tile_size * 0.5
#
			#enemy.global_position = world_pos
			#enemies_root.add_child(enemy)


func _unhandled_input(event):
	# Check if the input event is a left mouse button press.
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		# Get the direction from the player to the mouse.
		print("Mouse Event: ", event)
		var direction = get_global_mouse_position() - player.position
		
		# We normalize the direction to get a unit vector.
		direction = direction.normalized()
		
		# Spawn the fireball and pass the direction to it.
		spawn_fireball(direction)

func spawn_fireball(direction):
	var now = Time.get_unix_time_from_system()
	print(now)
	
	if now - last_attack < attack_cooldown:
		return;
	
	# Create an instance of the fireball scene.
	var fireball = fireball_scene.instantiate()
	
	# Set the fireball's initial position and rotation.
	fireball.position = $Player.position
	fireball.rotation = direction.angle()
	
	# Set the fireball's direction.
	fireball.direction = direction
	
	# Add the fireball to the scene tree.
	get_parent().add_child(fireball)
	last_attack = now;
