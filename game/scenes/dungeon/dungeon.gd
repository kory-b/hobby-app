extends Node2D

# How many enemies per room (you can tweak these in the Inspector)
@export var min_enemies_per_room: int = 1
@export var max_enemies_per_room: int = 3
@export var enemy_scene: PackedScene = preload("res://game/entities/enemies/enemy/enemy.tscn")

@export var world_size: Vector2i = Vector2i(500, 500) # The size of the dungeon in tiles.
@export var min_rooms: int = 5 # The minimum number of rooms to generate.
@export var max_rooms: int = 10 # The maximum number of rooms to generate.
@export var min_room_size: int = 25 # The minimum size (width and height) of a room.
@export var max_room_size: int = 30 # The maximum size (width and height) of a room.
@export var hallway_width: int = 5 # The width of the hallways.
@export var max_hall_length: int = 40 # max tiles per straight run
@export var dungeon_seed: int = 0 # The seed for the random number generator. A value of 0 means a random seed.
@export var floors: int = 10
# --- TILEMAP CONFIGURATION ---
@onready var player: CharacterBody2D = $Player
@onready var dungeon_manager: DungeonManager = $DungeonManager
@onready var enemy_manager: EnemyManager = $EnemyManager

# --- PRIVATE VARIABLES ---
var _player_spawn_pos: Vector2i
var _exit_pos: Vector2i
var dungeon_start_time: float
var dungeon_timer: Timer
var _current_floor: int = 1
# --- GODOT LIFECYCLE METHODS ---
func _ready():
	# Add this scene to the "dungeon" group for easy reference
	add_to_group("dungeon")
	
	# Set up the 20-minute dungeon timer
	dungeon_timer = $GameTimer
	dungeon_timer.wait_time = 1200.0 # 20 minutes in seconds
	dungeon_timer.timeout.connect(_on_dungeon_timeout)
	dungeon_timer.one_shot = true
	
	# Record start time and start the timer
	dungeon_start_time = Time.get_time_dict_from_system()["hour"] * 3600.0 + Time.get_time_dict_from_system()["minute"] * 60.0 + Time.get_time_dict_from_system()["second"]
	dungeon_timer.start()
	
	# Initialize GlobalState for this dungeon run
	GlobalState.dungeon_timed_out = false
	GlobalState.dungeon_start_time = dungeon_start_time

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

func pause() -> void:
	$"/root/SceneManager".change_scene("res://game/ui/pause_screen/pause_screen.tscn")
	pass # Replace with function body.


func _on_dungeon_timeout() -> void:
	# Set timeout flag and calculate time spent (20 minutes = 1200 seconds)
	GlobalState.dungeon_timed_out = true
	GlobalState.dungeon_time_spent = 1200.0 # Full 20 minutes when timed out
	
	# Transition to summary screen
	SceneManager.change_scene("res://game/ui/summary_screen/summary_screen.tscn")

func leave_dungeon_floor(body: Node2D) -> void:
	# Calculate time spent when leaving normally (not timeout)
	var current_time = Time.get_time_dict_from_system()["hour"] * 3600.0 + Time.get_time_dict_from_system()["minute"] * 60.0 + Time.get_time_dict_from_system()["second"]
	GlobalState.dungeon_time_spent = current_time - dungeon_start_time
	GlobalState.dungeon_timed_out = false
	
	if _current_floor >= floors:
		SceneManager.change_scene("res://game/ui/victory_screen/victory_scene.tscn")
	
	_current_floor += 1
	dungeon_manager.init_dungeon()
	enemy_manager.spawn_enemies()

func get_remaining_time() -> float:
	"""Get remaining time in seconds for UI display"""
	if dungeon_timer:
		return dungeon_timer.time_left
	return 0.0

func format_time(seconds: float) -> String:
	"""Format seconds into MM:SS format"""
	var minutes = int(seconds) / 60
	var secs = int(seconds) % 60
	return "%02d:%02d" % [minutes, secs]
