extends Area3D


## The path to the Node that is considered the "pick-upper" for a Pickup
@export var root:NodePath = ^".."


func _init() -> void:
	area_entered.connect(_on_area_entered)


func _on_area_entered(pickup:PickupArea) -> void:
	pickup.pick_up_request(get_node(root))
