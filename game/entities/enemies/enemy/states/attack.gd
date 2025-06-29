extends State

@onready var anim: AnimatedSprite2D = $"../../EnemyTexture"

@onready var aggression_area: Area2D = $"../../Aggression Area"
@onready var idle: Node = $"../Idle"

var t: float = 0.0

func enter() -> void:
	print("Enemy Enter Attack")
	pass
	
func exit() -> void:
	print("Enemy Exit Attack")
	pass

func process_input(event: InputEvent) -> State:
	return null
	
func process_frame(delta: float) -> State:
	return null
	
func process_physics(delta: float) -> State:
	if !aggression_area.has_overlapping_bodies():
		return idle
	var target = aggression_area.get_overlapping_bodies()[0]
	parent.velocity = (target.position - parent.position).normalized() * parent.speed
	parent.move_and_slide()
	
	if parent.velocity.length() > 0:
		anim.play("fly")
		
	return null
