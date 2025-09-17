@icon("res://globals/components/pickup/pickup_area/pickup_3d.svg")
class_name PickupArea
extends Area3D


signal picked_up(by:Node)


func pick_up_request(by:Node) -> void:
	picked_up.emit(by)
