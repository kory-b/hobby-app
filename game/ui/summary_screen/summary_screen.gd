extends Node2D


@onready var shard_label: Label = $ShardsLabel


func _ready() -> void:
	shard_label.text = "You Earned : " + str(GlobalState.shards) + " gold"
	
	# Add timeout and time information
	var status_text = ""
	if GlobalState.dungeon_timed_out:
		status_text = "TIME'S UP! Dungeon run ended after 20 minutes."
	else:
		status_text = "Dungeon completed!"
	
	# Format time spent
	var time_spent_formatted = format_time(GlobalState.dungeon_time_spent)
	status_text += "\nTime spent: " + time_spent_formatted
	
	# Update the label or create a new one for status
	if has_node("StatusLabel"):
		$StatusLabel.text = status_text
	else:
		print("Summary: ", status_text)


func format_time(seconds: float) -> String:
	"""Format seconds into MM:SS format"""
	var minutes = int(seconds) / 60
	var secs = int(seconds) % 60
	return "%02d:%02d" % [minutes, secs]


func main_menu() -> void:
	SceneManager.change_scene("res://game/ui/main_menu/main_menu.tscn")


func enter_town() -> void:
	SceneManager.change_scene("res://game/scenes/town/town.tscn")
