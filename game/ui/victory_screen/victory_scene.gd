extends Node


func main_menu() -> void:
	SceneManager.change_scene("res://game/ui/main_menu/main_menu.tscn")


func return_to_town() -> void:
	SceneManager.change_scene("res://game/scenes/town/town.tscn")
