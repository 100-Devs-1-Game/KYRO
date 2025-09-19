extends Node3D


@export var boost_increase:float = 1.0


func _on_pickup_area_picked_up(by:Player) -> void:
	by.boost += boost_increase
