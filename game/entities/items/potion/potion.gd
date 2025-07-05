class_name Potion extends Area2D

@export var heal_amount: int = 100


func picked_up(body: Node2D) -> void:
	if body is Player:
		#GlobalState.pickup_item(self)
		queue_free()
	pass
