@icon("res://globals/components/hurtbox/hitbox_3d.svg")
class_name Hurtbox
extends Area3D


signal took_damage(damage:int)


func take_damage(damage:int) -> void:
	took_damage.emit(damage)
