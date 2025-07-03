extends CharacterBody2D
class_name Player

@onready var state_machine: Node = $StateMachine
@onready var health_component: HealthComponent = $HealthComponent
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var stat_component: StatComponent = %StatComponent

var placeholder := true

func _ready() -> void:
	health_component.init_health(1000)
	progress_bar.init_value(1000)
	state_machine.init(self)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float):
	state_machine.process_physics(delta)
	
func _process(delta: float) -> void:
	state_machine.process_frame(delta)

func damage(damage: int) -> void:
	print("Damage: ", damage, " Defense: ", stat_component.defense)
	health_component.take_damage(damage - stat_component.defense)

func heal(health: int) -> void:
	print("healed")
	health_component.heal(health)

func died() -> void:
	SceneManager.change_scene("res://game/ui/summary_screen/summary_screen.tscn")
