class_name GunData
extends Resource


@export var gun_held:PackedScene
@export var gun_manager:PackedScene


func create_manager(raycast:RayCast3D) -> Node:
	var instance := gun_manager.instantiate()
	instance.raycast = raycast
	instance.load_data(self)
	return instance
