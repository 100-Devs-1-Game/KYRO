extends Node3D


func _on_pickup_area_picked_up(by: Node) -> void:
	if not is_instance_valid(by.gun_manager):
		return
	
	by.gun_manager.reserve_ammo += 1
	by.ammo_count.reserve_ammo += 1 # Hack
	queue_free()
