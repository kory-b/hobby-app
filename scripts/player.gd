# scripts/player.gd
extends CharacterBody2D

const SPEED := 200.0

@onready var link := $LinkTexture

var last_direction := "down"

var placeholder := true

func _physics_process(_delta):
	var input_vector := Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)

	if input_vector != Vector2.ZERO:
		input_vector = input_vector.normalized()
		velocity = input_vector * SPEED

		if link.is_visible_in_tree():
		# Animation logic: left/right takes priority
			if input_vector.x > 0:
				link.play("walk_right")
				last_direction = "right"
			elif input_vector.x < 0:
				link.play("walk_left")
				last_direction = "left"
			elif input_vector.y > 0:
				link.play("walk_down")
				last_direction = "down"
			elif input_vector.y < 0:
				link.play("walk_up")
				last_direction = "up"
	else:
		velocity = Vector2.ZERO
		if link.is_visible_in_tree():
			link.play("face_%s" % last_direction)

	move_and_slide()

	# Print the size of the viewport.
	#print("Viewport Resolution is: ", get_viewport().get_visible_rect().size)
	#pass

func gotoMainMenu() -> void:
	$"/root/SceneManager".change_scene("res://scenes/main.tscn")
