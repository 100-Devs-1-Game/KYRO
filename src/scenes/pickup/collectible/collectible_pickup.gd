extends Node3D


func _on_pickup_area_picked_up(by: Player) -> void:
	by.collectible_count += 1
	queue_free()
