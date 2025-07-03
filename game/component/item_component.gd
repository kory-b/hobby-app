class_name ItemComponent extends Node

var health: int = 0
var defense: int = 0
var movement_speed: int = 0
var aoe: int = 0
var type: GlobalState.ItemTypes 

func apply(stat_component: StatComponent):
	if type == GlobalState.ItemTypes.HAT:
		print("Applying Hat")
		pass
	elif type == GlobalState.ItemTypes.ROBE:
		print("Applying Robe")
		pass
	elif type == GlobalState.ItemTypes.SHIELD:
		print("Applying Shield")
		pass
	elif type == GlobalState.ItemTypes.BOOTS:
		print("Applying Boots")
		pass	
