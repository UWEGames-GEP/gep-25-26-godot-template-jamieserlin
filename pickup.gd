extends Node3D
@onready var item_sprite = %ItemSprite
@export var item_data: ItemData:
	get():
		return item_data

func _ready() -> void:
	item_sprite.texture = item_data.texture
