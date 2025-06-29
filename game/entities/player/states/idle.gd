extends State
class_name Idle

@onready var link: AnimatedSprite2D = $"../../LinkTexture"
@onready var move: Move = $"../Move"

const SPEED := 200.0


var last_direction := "down"

func enter() -> void:
	print("Play Entered Idle")
	pass
	
func exit() -> void:
	print("Play Exited Idle")
	pass

func process_input(event: InputEvent) -> State:
	var input_vector := Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)
	if input_vector == Vector2(0,0):
		return null
	else:
		return move
	
func process_frame(delta: float) -> State:
	return null
	
func process_physics(delta: float) -> State:
	parent.velocity = Vector2.ZERO
	if link.is_visible_in_tree():
		link.play("face_%s" % last_direction)

	parent.move_and_slide()
	return null
