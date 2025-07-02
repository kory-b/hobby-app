class_name HealthComponent
extends Node

## Signal emitted when health changes. Passes the new health value.
signal health_changed(new_health)
## Signal emitted when health reaches zero.
signal died

## The maximum health value.
@export var max_health: float = 100.0

var current_health: float


func _ready():
	init_health(max_health)
	

func init_health(amount:int):
	max_health = amount
	current_health = amount
	print("[Health]: Init Health: ", current_health)

func _set_health(health_amount: int):
	current_health = clamp(current_health + health_amount, 0, max_health)
	print("[Health]: Health Changed: ", current_health)
	health_changed.emit(current_health)
	if current_health == 0:
		died.emit()
		

## Reduces current health by the damage amount.
func take_damage(damage_amount: float):
	print("[Health]: Taking_damage: ", damage_amount)
	_set_health(-damage_amount)

## Reduces current health by the damage amount.
func heal(heal_amount: float):
	print("[Health]: Healing: ", heal_amount)
	_set_health(heal_amount)
	
	
