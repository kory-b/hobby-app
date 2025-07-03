extends Node
class_name Robe

@export var bonus_health: int = 0

func picked_up(body: Node2D) -> void:
	if body is Player:
		body.health_component.max_health += bonus_health
		body.health_component.current_health += bonus_health
		queue_free()
	pass
