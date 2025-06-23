# scripts/player.gd
extends CharacterBody2D

const SPEED := 200.0

@onready var anim_sprite := $AnimatedSprite2D

var last_direction := "down"

func _physics_process(_delta):
	var input_vector := Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)

	if input_vector != Vector2.ZERO:
		input_vector = input_vector.normalized()
		velocity = input_vector * SPEED

		# Animation logic: left/right takes priority
		if input_vector.x > 0:
			anim_sprite.play("walk_right")
			last_direction = "right"
		elif input_vector.x < 0:
			anim_sprite.play("walk_left")
			last_direction = "left"
		elif input_vector.y > 0:
			anim_sprite.play("walk_down")
			last_direction = "down"
		elif input_vector.y < 0:
			anim_sprite.play("walk_up")
			last_direction = "up"
	else:
		velocity = Vector2.ZERO
		anim_sprite.play("face_%s" % last_direction)

	move_and_slide()
