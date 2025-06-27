# SceneManager.gd
# This script should be set up as an Autoload (Singleton) in your project settings.
# To do this:
# 1. Go to Project -> Project Settings -> Autoload.
# 2. Click the 'Add' button (folder icon), navigate to this script (SceneManager.gd), and select it.
# 3. Ensure 'Enable' is checked. The Node Name will default to "SceneManager".

extends Node

# Stores a reference to the currently active scene.
var current_scene: Node = null

func _ready() -> void:
	# Get the initial scene that was loaded when the game started.
	# The root viewport contains the currently active scene.
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)
	print("SceneManager: Initial scene loaded: ", current_scene.name)

# Changes the current scene to a new one specified by its path.
# @param path: The path to the scene file (e.g., "res://scenes/main_menu.tscn").
# @param fade_duration: Optional duration for a fade effect (not implemented here, but a placeholder).
func change_scene(path: String) -> void:
	# Check if the path is valid and points to a scene resource.
	if not ResourceLoader.exists(path, "PackedScene"):
		push_error("SceneManager: Error - Scene path does not exist or is not a PackedScene: ", path)
		return

	print("SceneManager: Attempting to change scene to: ", path)

	# Load the new scene resource.
	var new_scene_resource: PackedScene = load(path)
	if new_scene_resource == null:
		push_error("SceneManager: Error loading scene resource from path: ", path)
		return

	# Instance the new scene.
	var new_scene_instance: Node = new_scene_resource.instantiate()
	if new_scene_instance == null:
		push_error("SceneManager: Error instantiating new scene from path: ", path)
		return

	# Add the new scene as a child of the root viewport.
	var root = get_tree().root
	root.add_child(new_scene_instance)

	# If there was a current scene, queue it for deletion.
	# Using `queue_free()` is crucial for safe deletion, especially for nodes
	# that might still be processing frames or signals.
	if current_scene != null and is_instance_valid(current_scene):
		# Remove the old scene from the tree before freeing it.
		current_scene.call_deferred("free")
		print("SceneManager: Old scene '", current_scene.name, "' queued for freeing.")
	else:
		print("SceneManager: No valid old scene to free.")

	# Set the newly loaded scene as the current scene.
	current_scene = new_scene_instance
	# Set the newly loaded scene as the active scene in the SceneTree.
	# This ensures that input, physics, and rendering are directed to it.
	get_tree().current_scene = new_scene_instance

	print("SceneManager: Successfully changed to scene: ", current_scene.name)

# Example usage from another script (e.g., a button's _pressed() signal or a game level script):
#
# func _on_StartGameButton_pressed():
#     SceneManager.change_scene("res://scenes/level_1.tscn")
#
# func _on_GameOverScreen_restart_button_pressed():
#     SceneManager.change_scene("res://scenes/main_menu.tscn")
#
# Note: You can call SceneManager from any script after it's set up as an Autoload.
