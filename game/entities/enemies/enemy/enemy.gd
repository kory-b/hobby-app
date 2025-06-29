class_name Enemy
extends CharacterBody2D

@export var speed: float = 80.0

@onready var anim: AnimatedSprite2D = $EnemyTexture

var t: float = 0.0
var attack_power: int = 100

func _ready():
	anim.play("idle")
	$HealthComponent.max_health = 50


func _physics_process(delta):
	t += delta                     # accumulate seconds
	velocity.x = speed * sin(t)    # float back and forth
	move_and_slide()

	# animation switch
	if velocity.length() > 0:
		anim.play("fly")
	else:
		anim.play("idle")


func _on_unit_died() -> void:
	print("Enemy Died!")
	GlobalState.shards += 10
	queue_free()
	
func take_damage(damage):
	$HealthComponent.take_damage(damage)
	
func attack(body: Node2D) -> void:
	print ("Player Damaged")
	if body is Player:
		body.damage(attack_power)
