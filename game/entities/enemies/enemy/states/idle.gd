extends State

@onready var anim: AnimatedSprite2D = $"../../EnemyTexture"

var t: float = 0.0

func enter() -> void:
	print("Enemy Enter Idle")
	pass
	
func exit() -> void:
	print("Enemy Exit Idle")
	pass

func process_input(event: InputEvent) -> State:
	return null
	
func process_frame(delta: float) -> State:
	return null
	
func process_physics(delta: float) -> State:
	t += delta
	parent.velocity.x = parent.stats.movement_speed * sin(t)    # float back and forth
	parent.move_and_slide()

	# animation switch
	if parent.velocity.length() > 0:
		anim.play("fly")
	else:
		anim.play("idle")
	return null
