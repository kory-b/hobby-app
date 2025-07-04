extends Node
class_name Robe

@export var bonus_health: int = 0
@export var item_data: ItemData

func picked_up(body: Node2D) -> void:
	if body is Player:
		GlobalState.pickup_item(item_data)
		queue_free()
	pass
