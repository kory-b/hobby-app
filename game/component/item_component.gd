class_name ItemComponent extends Node

@export var health: int = 0
@export var defense: int = 0
@export var movement_speed: int = 0
@export var aoe: int = 0
@export var type: GlobalState.ItemTypes

func apply(stat_component: StatComponent):
	if type == GlobalState.ItemTypes.HAT:
		print("Applying Hat")
		pass
	elif type == GlobalState.ItemTypes.ROBE:
		print("Applying Robe")
		stat_component.max_health += health
	elif type == GlobalState.ItemTypes.SHIELD:
		print("Applying Shield")
		pass
	elif type == GlobalState.ItemTypes.BOOTS:
		print("Applying Boots")
		pass	
	print("Updated Stats: ", stat_component)
