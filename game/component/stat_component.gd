class_name StatComponent extends Node


signal health_changed(new_health)
signal died

@export var current_health: int = 0:
	set(val):
		current_health = clamp(val, 0, max_health)
		print("[Health]: Health Changed: ", current_health)
		health_changed.emit(current_health)
		if current_health == 0:
			died.emit()
@export var max_health: int = 0
@export var defense: int = 0 
@export var movement_speed: int = 0 
@export var attack_speed: int = 0 

func init_health(amount:int):
	max_health = amount
	current_health = amount
	print("[Health]: Init Health: ", current_health)

## Reduces current health by the damage amount.
func take_damage(damage_amount: float):
	damage_amount = max(damage_amount,0)
	print("[Health]: Taking_damage: ", damage_amount)
	current_health = current_health - damage_amount

## Reduces current health by the damage amount.
func heal(heal_amount: float):
	print("[Health]: Healing: ", max(heal_amount, 0))
	current_health += heal_amount
	
	
