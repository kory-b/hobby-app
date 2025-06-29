extends Node



func resume() -> void:
	SceneManager.change_scene("res://game/scenes/dungeon/dungeon.tscn")



func main_menu() -> void:
	SceneManager.change_scene("res://game/ui/main_menu/main_menu.tscn")
