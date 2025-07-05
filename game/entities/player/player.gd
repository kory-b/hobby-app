extends CharacterBody2D
class_name Player

@onready var state_machine: Node = $StateMachine
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var current_stats: StatComponent = %CurrentStats
@onready var base_stats: StatComponent = %BaseStats

var placeholder := true


func _ready() -> void:
	progress_bar.init_value(base_stats.max_health)
	state_machine.init(self)
	current_stats.copy(base_stats)
	GlobalState.item_equipped.connect(item_equipped)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float):
	state_machine.process_physics(delta)
	
func _process(delta: float) -> void:
	state_machine.process_frame(delta)

func damage(damage: int) -> void:
	print("Damage: ", damage, " Defense: ", current_stats.defense)
	current_stats.take_damage(damage - current_stats.defense)

func heal(health: int) -> void:
	print("healed")
	current_stats.heal(health)

func died() -> void:
	SceneManager.change_scene("res://game/ui/summary_screen/summary_screen.tscn")
	
func item_equipped() -> void:
	print("Updating Stats")
	current_stats.copy(base_stats)
	for item in GlobalState.equipment.values():
		item.apply(current_stats)
	progress_bar.max_value = current_stats.max_health
