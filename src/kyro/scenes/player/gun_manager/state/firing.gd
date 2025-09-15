extends State


var cooldown_time:float = 0.0


@export_group("State Connectons", "state_")
@export var state_idle:State


func _state_entered() -> void:
	cooldown_time = 1.0 / owner.fire_rate
	owner.animation_shoot_requested.emit(cooldown_time)
	owner.fire_bullet()
	owner.clip_ammo -= 1
	owner.ammo_counts_updated.emit()


func _state_process(delta: float) -> void:
	cooldown_time -= delta
	if cooldown_time > 0:
		return
	if can_fire() and firing_wanted():
		machine.to_state(self) # funny
	else:
		machine.to_state(state_idle)


func _state_physics_process(delta: float) -> void:
	pass


func _state_exited() -> void:
	pass


func can_fire() -> bool:
	return owner.clip_ammo > 0


func firing_wanted() -> bool:
	return Input.is_action_pressed(&"shoot")
