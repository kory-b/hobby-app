extends Area2D
class_name Potion
@export var heal_amount: int = 100


func picked_up(body: Node2D) -> void:
	if body is Player:
		body.heal(heal_amount)
		queue_free()
	pass
