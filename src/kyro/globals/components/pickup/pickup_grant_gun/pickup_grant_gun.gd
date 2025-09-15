extends Node

@export var data:GunData


func _on_pickup_area_picked_up(by:Node) -> void:
	by.add_gun(data)
