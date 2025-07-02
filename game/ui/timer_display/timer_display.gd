extends Control

@onready var timer_label: Label = $TimerLabel
@export var dungeon_scene: Node2D

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if dungeon_scene and dungeon_scene.has_method("get_remaining_time"):
		var remaining_time = dungeon_scene.get_remaining_time()
		var formatted_time = format_time(remaining_time)
		
		# Change color based on remaining time
		if remaining_time <= 120: # Last 2 minutes - red
			timer_label.modulate = Color.RED
		elif remaining_time <= 300: # Last 5 minutes - yellow
			timer_label.modulate = Color.YELLOW
		else:
			timer_label.modulate = Color.WHITE
		
		timer_label.text = "Time: " + formatted_time
	else:
		timer_label.text = "Time: --:--"

func format_time(seconds: float) -> String:
	"""Format seconds into MM:SS format"""
	var minutes = int(seconds) / 60
	var secs = int(seconds) % 60
	return "%02d:%02d" % [minutes, secs]
