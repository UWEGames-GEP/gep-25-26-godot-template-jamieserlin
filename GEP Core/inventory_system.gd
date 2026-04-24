extends Node

@onready var inventory_scene: Control = %InventoryScene
@onready var player: Node = %Player
@export var inventory_open: bool = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("inventory"):
		inventory_open = !inventory_open
		
		if inventory_open:
			inventory_scene.visible = true
			get_tree().paused = true #pauses game!
			
			# Stop player input
			player.set_process_input(false)
			player.set_process_unhandled_input(false)
			
			# Free the mouse
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			
		else:
			inventory_scene.visible = false
			
			get_tree().paused = false
			# Restore player input
			player.set_process_input(true)
			player.set_process_unhandled_input(true)
			
			# Capture mouse again (for FPS-style control)
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
