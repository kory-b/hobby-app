extends Node2D

@onready var shards_label: Label = $"Shards Label"

func _ready() -> void:
	shards_label.text = "You have " + str(GlobalState.shards) + " shards"
	

func enter_dungeon() -> void:
	SceneManager.change_scene("res://game/scenes/dungeon/dungeon.tscn")
