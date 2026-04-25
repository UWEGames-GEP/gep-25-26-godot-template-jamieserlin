extends Node3D

@onready var item_sprite = %ItemSprite
var item_data: ItemData

func set_item_data(data: ItemData) -> void:
	item_data = data

	# safe ONLY if node is in tree
	if is_inside_tree():
		item_sprite.texture = item_data.texture

func _ready() -> void:
	if item_data:
		item_sprite.texture = item_data.texture
