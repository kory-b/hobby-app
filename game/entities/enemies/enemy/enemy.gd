class_name Enemy
extends CharacterBody2D

@onready var state_machine: Node = $StateMachine
@onready var damage_component: DamageComponent = $DamageComponent

@export var speed: float = 80.0
@onready var anim: AnimatedSprite2D = $EnemyTexture
@onready var aggression_area: Area2D = $"Aggression Area"
@export var item_manager: ItemManager

func _ready():
	anim.play("idle")
	$HealthComponent.max_health = 50
	state_machine.init(self)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float):
	state_machine.process_physics(delta)
	
func _process(delta: float) -> void:
	state_machine.process_frame(delta)

func attack(body: Node2D) -> void:
	print ("Player Damaged")
	if body is Player:
		body.damage(damage_component.damage)

func _on_unit_died() -> void:
	print("Enemy Died!")
	GlobalState.shards += 10
	item_manager.spawn_item(position)
	queue_free()
	
func take_damage(damage):
	$HealthComponent.take_damage(damage)


func aggression(body: Node2D) -> void:
	state_machine.change_state($StateMachine/Attack)
