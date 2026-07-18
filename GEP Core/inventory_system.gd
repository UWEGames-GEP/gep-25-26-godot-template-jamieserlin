extends Node
@onready var inventory_scene: Control = %InventoryScene
@onready var player: Node = %Player
@export var inventory_open: bool = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	inventory_scene.visible = true
	await get_tree().process_frame
	inventory_scene.visible = false

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("inventory"):
		set_inventory_open(!inventory_open)

func set_inventory_open(value: bool) -> void:
	inventory_open = value
	inventory_scene.visible = inventory_open
	get_tree().paused = inventory_open
	player.set_process_input(!inventory_open)
	player.set_process_unhandled_input(!inventory_open)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE if inventory_open else Input.MOUSE_MODE_CAPTURED)
