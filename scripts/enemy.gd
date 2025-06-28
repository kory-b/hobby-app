extends CharacterBody2D
class_name Enemy

@export var speed: float = 80.0

@onready var anim: AnimatedSprite2D = $EnemyTexture

var t: float = 0.0

func _ready():
	print("Anim node is: ", anim)
	anim.play("idle")

func _physics_process(delta):
	t += delta                     # accumulate seconds
	velocity.x = speed * sin(t)    # float back and forth
	move_and_slide()

	# animation switch
	if velocity.length() > 0:
		anim.play("fly")
	else:
		anim.play("idle")
