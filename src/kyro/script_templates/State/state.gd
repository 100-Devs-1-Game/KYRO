# meta-description: Empty State methods, ready to be overridden.
# meta-default: true
extends State


func _state_entered() -> void:
	pass


func _state_process(delta: float) -> void:
	pass


func _state_physics_process(delta: float) -> void:
	pass


func _state_exited() -> void:
	pass
