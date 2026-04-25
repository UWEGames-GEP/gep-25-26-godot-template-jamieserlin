extends Node3D

@onready var item_sprite = %ItemSprite
@export var item_data: ItemData

func set_item_data(data: ItemData) -> void:
	print("SET ITEM:", data, data.texture)
	item_data = data
	
	# Ensure this works even if called before _ready
	if item_sprite:
		item_sprite.texture = item_data.texture

func _ready() -> void:
	# Fallback for editor-set data
	print("READY ITEM:", item_data)
	if item_data and item_sprite.texture == null:
		print("here")
		item_sprite.texture = item_data.texture

func give_to_player(player):
	player.add_item_to_inventory(item_data)
	queue_free()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		give_to_player(body)
