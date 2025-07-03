extends Node

@onready var game_scene: Node2D = %GameScene

func _ready() -> void:
	SceneManager.init(game_scene, "res://game/ui/main_menu/main_menu.tscn")
