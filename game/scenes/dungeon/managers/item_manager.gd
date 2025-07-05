extends Node
class_name ItemManager


var potion_scene: PackedScene = preload("res://game/entities/items/potion/potion.tscn")
var robe_scene: PackedScene = preload("res://game/entities/items/robe/robe.tscn")
var boots_scene:PackedScene = preload("res://game/entities/items/boots/boots.tscn")
func spawn_potion(position: Vector2i):
	print("[ItemManager] Spawning Item:", position)
	var potion = potion_scene.instantiate() as Potion
	potion.global_position = position
	self.add_child(potion)

func spawn_robe(position: Vector2i):
	print("[ItemManager] Spawning Item:", position)
	var robe = robe_scene.instantiate() as Robe
	robe.global_position = position
	self.add_child(robe)

func spawn_boots(position: Vector2i):
	print("[ItemManager] Spawning Item:", position)
	var boots = boots_scene.instantiate() as Boots
	boots.global_position = position
	self.add_child(boots)
