extends ProgressBar

func init_value(value: int) -> void:
	min_value = 0
	value = value
	max_value = value


func _on_current_stats_health_changed(new_health: Variant) -> void:
	print("Updating Health Component: ", new_health)
	value = new_health
