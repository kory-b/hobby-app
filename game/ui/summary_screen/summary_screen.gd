extends Node2D


@onready var shard_label: Label = $ShardsLabel


func _ready() -> void:
	shard_label.text = "You Earned : " + str(GlobalState.shards) +  "gold"
	


func main_menu() -> void:
	SceneManager.change_scene("res://game/ui/main_menu/main_menu.tscn")


func enter_town() -> void:
	SceneManager.change_scene("res://game/scenes/town/town.tscn")
