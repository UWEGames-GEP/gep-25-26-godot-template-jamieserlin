extends GridContainer

@export var inventory_slot_scene: PackedScene
@export var dimensions: Vector2i

const SLOT_SIZE: int = 16
var slot_data: Array[Node] = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_slots()
	init_slot_data()


func create_slots() -> void:
	self.columns = dimensions.x
	for y in dimensions.y:
		for x in dimensions.x:
			var inventory_slot = inventory_slot_scene.instantiate()
			add_child(inventory_slot)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.is_pressed():
			var index = get_slot_index_from_coords(get_global_mouse_position())
			print(index, get_coords_from_slot_index(index))
	
func init_slot_data() -> void:
	slot_data.resize(dimensions.x * dimensions.y)
	slot_data.fill(null)

func attempt_to_add_item_data(item: Node) -> bool:
	var slot_index: int = 0
	while slot_index < slot_data.size():
		if item_fits(slot_index, item.data.dimensions):
			break
		slot_index += 1
	if slot_index >= slot_data.size():
		return false
	
	for y in item.data.dimensions.y:
		for x in item.data.dimensions.x:
			slot_data[slot_index + x + y * columns] = item
	
	item.set_init_position(get_coords_from_slot_index(slot_index))
	return true

func item_fits(index: int, dimensions: Vector2i) -> bool:
	for y in dimensions.y:
		for x in dimensions.x:
			var cur_index = index + x + y * columns
			if cur_index >= slot_data.size():
				return false
			if slot_data[cur_index] != null:
				return false
			var split = index / columns != (index + x) / columns
			if split:
				return false
	return true

func get_slot_index_from_coords(coords: Vector2i) -> int:
	coords -= Vector2i(self.global_position)
	coords = coords / SLOT_SIZE
	var index = coords.x + coords.y * columns
	return index

func get_coords_from_slot_index(index: int) -> Vector2i:
	var row = index / columns
	var column = index % columns
	return Vector2i(global_position) + Vector2i(column * SLOT_SIZE, row * SLOT_SIZE)
