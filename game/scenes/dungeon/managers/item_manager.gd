extends Node
class_name ItemManager


var potion_scene: PackedScene = preload("res://game/entities/items/potion/potion.tscn")
var robe_scene: PackedScene = preload("res://game/entities/items/robe/robe.tscn")

func spawn_potion(position: Vector2i):
	print("[ItemManager] Spawning Item:", position)
	var potion = potion_scene.instantiate() as Potion
	potion.global_position = position
	self.add_child(potion)

func spawn_robe(position: Vector2i):
	print("[ItemManager] Spawning Item:", position)
	var robe = robe_scene.instantiate() as Robe
	robe.global_position = position
	robe.bonus_health = 100
	self.add_child(robe)
