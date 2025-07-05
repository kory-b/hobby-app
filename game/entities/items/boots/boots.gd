class_name Boots extends Node


@onready var item_component: ItemComponent = $ItemComponent

func picked_up(body: Node2D) -> void:
	if body is Player:
		GlobalState.pickup_item(item_component)
		remove_child(item_component)
		queue_free()
