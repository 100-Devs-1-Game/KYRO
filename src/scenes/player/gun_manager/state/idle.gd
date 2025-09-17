extends State


@export_group("State Connectons", "state_")
@export var state_reload:State
@export var state_fire:State


func _state_entered() -> void:
	pass


func _state_process(delta: float) -> void:
	if state_fire.can_fire() and state_fire.firing_wanted():
		machine.to_state(state_fire)
		return
	if state_reload.can_reload() and state_reload.reload_wanted():
		machine.to_state(state_reload)
		return


func _state_physics_process(delta: float) -> void:
	pass


func _state_exited() -> void:
	pass
