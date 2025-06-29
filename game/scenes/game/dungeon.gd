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
@onready var player: CharacterBody2D = $Player
@onready var dungeon_manager: DungeonManager = $DungeonManager

# --- PRIVATE VARIABLES ---
var _player_spawn_pos: Vector2i
var _exit_pos: Vector2i

# --- GODOT LIFECYCLE METHODS ---
func _ready():
	pass

func _unhandled_input(event):
	# Check if the input event is a left mouse button press.
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		# Get the direction from the player to the mouse.
		print("Mouse Event: ", event)
		var direction = get_global_mouse_position() - player.position
		
		# We normalize the direction to get a unit vector.
		direction = direction.normalized()
		
		# Spawn the fireball and pass the direction to it.
		$FireballManager.spawn_fireball(player.position, direction)
