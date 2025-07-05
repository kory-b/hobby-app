extends Node

@onready var inventory_ui: CanvasLayer = preload("res://game/ui/inventory/inventory.tscn").instantiate() as CanvasLayer

func _ready() -> void:
	print("InventoryManager ready")
	add_child(inventory_ui)
	inventory_ui.visible = false
	set_process_unhandled_input(true)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		_toggle_inventory()

func _toggle_inventory() -> void:
	inventory_ui.visible = not inventory_ui.visible
	if inventory_ui.visible:
		print("Inventory opened")
	else:
		print("Inventory closed")
