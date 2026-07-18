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

	var drop_position = get_drop_position(player)
	pickup_instance.global_transform.origin = drop_position

	# remove from inventory
	var grid = get_parent().get_node("Inventory/ItemGrid")
	if grid:
		grid.remove_item_from_slot_data(held_item)
	held_item.queue_free()

func get_drop_position(player: Node3D) -> Vector3:
	var drop_distance := 1.5
	var forward = -player.global_transform.basis.z # Godot forward is -Z
	forward.y = 0
	forward = forward.normalized()

	var drop_pos = player.global_position + forward * drop_distance

	# raycast down to snap to the ground
	var space_state = player.get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(
		drop_pos + Vector3(0, 2, 0),
		drop_pos + Vector3(0, -5, 0)
	)
	var result = space_state.intersect_ray(query)
	if result:
		drop_pos.y = result.position.y + 0.1
	else:
		drop_pos.y = player.global_position.y # fallback if no ground hit

	return drop_pos
