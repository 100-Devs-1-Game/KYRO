class_name Target
extends Node3D


func _on_hurtbox_take_damage() -> void:
	queue_free()
