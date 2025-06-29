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
	# Initialize current health when the node enters the scene tree.
	current_health = max_health


## Reduces current health by the damage amount.
func take_damage(damage_amount: float):
	# [cite_start]In the future, we can factor in the 'Defense' stat here. [cite: 63]
	current_health -= damage_amount
	
	# Ensure health doesn't go below 0.
	current_health = max(current_health, 0)
	
	health_changed.emit(current_health)
	
	if current_health == 0:
		died.emit()
