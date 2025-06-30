extends Node
class_name ItemManager


var potion_scene: PackedScene = preload("res://game/entities/potion/potion.tscn")


func spawn_item(position: Vector2i):
	print("[ItemManager] Spawning Item:", position)
	var potion = potion_scene.instantiate() as Potion
	potion.global_position = position
	self.add_child(potion)
