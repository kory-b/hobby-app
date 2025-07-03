extends Node
class_name Robe

@export var bonus_health: int = 0

@onready var item_component: ItemComponent = $ItemComponent

func picked_up(body: Node2D) -> void:
	if body is Player:
		GlobalState.pickup_item(item_component)
		queue_free()
	pass
