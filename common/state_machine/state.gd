extends Node
class_name State

@export var move_speed: float = 400

@export var parent: Player

func enter() -> void:
	pass
	
func exit() -> void:
	pass

func process_input(event: InputEvent) -> State:
	return null
	
func process_frame(delta: float) -> State:
	return null
	
func process_physics(delta: float) -> State:
	return null
