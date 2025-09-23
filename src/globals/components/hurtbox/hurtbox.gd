@icon("res://globals/components/hurtbox/hitbox_3d.svg")
class_name Hurtbox
extends StaticBody3D


signal took_damage(damage:int)


@export var damage_multiplier:float = 1.0


func take_damage(damage:int) -> void:
	took_damage.emit(damage * damage_multiplier)
