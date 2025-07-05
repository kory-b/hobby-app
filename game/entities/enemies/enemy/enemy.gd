class_name Enemy
extends CharacterBody2D

@export var speed: float = 80.0
@export var item_manager: ItemManager

@onready var state_machine: Node = $StateMachine
@onready var damage_component: DamageComponent = $DamageComponent
@onready var stats: StatComponent = %Stats
@onready var anim: AnimatedSprite2D = $EnemyTexture
@onready var aggression_area: Area2D = $"Aggression Area"

@onready var health_bar: ProgressBar = $HealthBar


signal died(enemy: Enemy)

func _ready():
	anim.play("idle")
	state_machine.init(self)
	stats.init_health(stats.max_health)
	health_bar.init_value(stats.max_health)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float):
	state_machine.process_physics(delta)
	
func _process(delta: float) -> void:
	state_machine.process_frame(delta)

func attack(body: Node2D) -> void:
	print("Player Damaged")
	if body is Player:
		body.damage(damage_component.damage)

func _on_unit_died() -> void:
	print("Enemy Died!")
	GlobalState.shards += 10
	died.emit(self)
	queue_free()
	
func take_damage(damage):
	stats.take_damage(damage)

func aggression(body: Node2D) -> void:
	state_machine.change_state($StateMachine/Attack)
