extends Node2D


func _ready() -> void:
	display_inventory()

func display_inventory() -> void:
	print("Printing Inventory")
	for item in GlobalState.inventory:
		print (item.health)


func return_to_town() -> void:
	SceneManager.change_scene("res://game/scenes/town/town.tscn")
