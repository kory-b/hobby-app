extends ProgressBar

@export var health_component: HealthComponent


func _ready() -> void:
	min_value = 0
	max_value = health_component.max_health
	value = health_component.current_health
	

func _on_health_component_health_changed(new_health: Variant) -> void:
	value = health_component.current_health
