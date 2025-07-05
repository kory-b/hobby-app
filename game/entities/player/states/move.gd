extends State
class_name Move

@onready var link: AnimatedSprite2D = $"../../LinkTexture"
@onready var idle: Idle = $"../Idle"
@onready var current_stats: StatComponent = %CurrentStats

var last_direction := "down"

var input_vector : Vector2 = Vector2.ZERO

func enter() -> void:
	print("Play Entered Move")
	pass
	
func exit() -> void:
	print("Play Exited Move")
	pass


func process_input(event: InputEvent) -> State:
	input_vector = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)
	if input_vector == Vector2.ZERO:
		return idle
	else:
		return null
	
func process_frame(delta: float) -> State:
	return null
	
func process_physics(delta: float) -> State:
	input_vector = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)
	if input_vector == Vector2.ZERO:
		return idle

	parent.velocity = input_vector.normalized() * current_stats.movement_speed

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

	parent.move_and_slide()
	return null
