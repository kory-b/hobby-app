# util/global_state.gd

extends Node

@export var shards: int = 0
@export var dungeon_timed_out: bool = false
@export var dungeon_start_time: float = 0.0
@export var dungeon_time_spent: float = 0.0

enum ItemTypes {HAT, ROBE, SHIELD, BOOTS}

signal item_equipped
signal item_picked_up(item)

var inventory: Array = []
var equipment: Dictionary = {}
var max_inventory:int = 9

func pickup_item(item: ItemData):
	print("pickup")
	if inventory.size() < max_inventory:
		if !equipment.has(item.type):
			print("Automatically Equipping: ", item)
			equipment[item.type] = item
			item_equipped.emit(item)
		else:
			print("Item Picked Up: ", item)
			inventory.append(item)
		item_picked_up.emit(item)
		
		print("Inventory: ", inventory)

func equip_item(item):
	print("Equip Item: ", inventory)
	equipment[item.type] = item
