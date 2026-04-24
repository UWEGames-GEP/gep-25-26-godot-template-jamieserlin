extends Node3D
@onready var item_sprite = %ItemSprite
@export var item_data: ItemData:
	get():
		return item_data
		
@onready var collision_shape = %CollisionShape3D
func _ready() -> void:
	item_sprite.texture = item_data.texture

func give_to_player(player):
	player.add_item_to_inventory(item_data)
	queue_free()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		give_to_player(body)
