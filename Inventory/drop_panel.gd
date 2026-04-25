extends PanelContainer

@export var pickup_scene: PackedScene  # The scene that will be instantiated (the item being dropped)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		print("DROP clicked")
		drop_held_item()

func drop_held_item() -> void:
	var held_item = get_tree().get_first_node_in_group("held_item")
	if !held_item:
		return

	var player = get_tree().get_first_node_in_group("player")
	if !player:
		print("Player not found")
		return

	var pickup_instance = pickup_scene.instantiate()

	get_tree().current_scene.add_child(pickup_instance)

	pickup_instance.set_item_data(held_item.data)

	var drop_position = player.global_transform.origin + Vector3(0, 10, 0)
	pickup_instance.global_transform.origin = drop_position

	# remove from inventory
	var grid = get_parent().get_node("Inventory/ItemGrid")
	if grid:
		grid.remove_item_from_slot_data(held_item)

	held_item.queue_free()
