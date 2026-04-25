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
	print("DUPLICATED DATA:", held_item.data.duplicate(true))
	pickup_instance.set_item_data(held_item.data)
	get_tree().current_scene.add_child(pickup_instance)

	var player_pos = player.global_position
	var drop_position = player_pos + Vector3(0, 0.5, 2)	
	#^infront of the player by 1.5m
	
	pickup_instance.global_transform.origin = drop_position

	# remove from inventory
	var grid = get_parent().get_node("Inventory/ItemGrid")
	if grid:
		grid.remove_item_from_slot_data(held_item)

	held_item.queue_free()
