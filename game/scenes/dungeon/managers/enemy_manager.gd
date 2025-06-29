extends Node
class_name EnemyManager

# How many enemies per room (you can tweak these in the Inspector)
@export var min_enemies_per_room: int = 1
@export var max_enemies_per_room: int = 3
@export var enemy_scene: PackedScene = preload("res://game/entities/enemies/enemy/enemy.tscn")

@export var dungeon_manager: DungeonManager

@export var enemy_scenes: Array[PackedScene]

## The base number of enemies to spawn on floor 1.
@export var base_enemy_count: int = 3


func _ready():
	randomize()
	spawn_enemies()

func spawn_enemies():
	var tile_size = dungeon_manager.floor_layer.tile_set.tile_size
	for room in dungeon_manager.get_rooms():
		var count = randi_range(min_enemies_per_room, max_enemies_per_room)
		for i in range(count):
			var cell = Vector2i(
				randi_range(room.position.x, room.position.x + room.size.x - 1),
				randi_range(room.position.y, room.position.y + room.size.y - 1)
			)
			if dungeon_manager.floor_layer.get_cell_source_id(cell) != 0:
				continue

			var enemy = enemy_scene.instantiate() as Enemy

			var local_pos = dungeon_manager.floor_layer.map_to_local(cell)
			var world_pos = dungeon_manager.floor_layer.to_global(local_pos) + tile_size * 0.5

			enemy.global_position = world_pos
			self.add_child(enemy)
	
