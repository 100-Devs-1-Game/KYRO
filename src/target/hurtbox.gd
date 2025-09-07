class_name Hurtbox
extends Area3D

signal take_damage

func hit():
	take_damage.emit()
	
