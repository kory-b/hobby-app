extends ProgressBar

@export var health_component: HealthComponent


func _ready() -> void:
	init_value(health_component.max_health)

func init_value(value: int) -> void:
	min_value = 0
	value = value
	max_value = value

func _on_health_component_health_changed(new_health: Variant) -> void:
	print("Updating Health Component: ", new_health)
	value = new_health
