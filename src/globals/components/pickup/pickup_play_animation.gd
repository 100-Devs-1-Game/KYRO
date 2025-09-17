extends Node

@export var player:AnimationPlayer
@export var animation:StringName

func _on_pickup_area_picked_up(_by:Node) -> void:
	player.play(animation)
