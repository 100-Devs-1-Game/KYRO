class_name State
extends Node

var machine: StateMachine:
	get():
		return get_parent()


func _state_entered() -> void:
	pass


func _state_process(delta: float) -> void:
	pass


func _state_physics_process(delta: float) -> void:
	pass


func _state_exited() -> void:
	pass
