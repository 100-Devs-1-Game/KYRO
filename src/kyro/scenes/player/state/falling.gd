extends State


@export var gravity_multiplier:float = 2.0


func _state_entered() -> void:
	pass


func _state_process(delta: float) -> void:
	pass


func _state_physics_process(delta: float) -> void:
	if owner.can_jump() and Input.is_action_just_pressed("ui_accept"):
		owner.jump()
		machine.current_state._state_physics_process(delta)
		return
	owner.do_forward_movement(delta)
	owner.do_strafe_movement(delta)
	owner.do_damping(delta)
	owner.do_gravity(delta * gravity_multiplier)
	
	owner.move_and_slide()
	owner.do_coyote_time(delta)
	
	if owner.is_on_floor():
		machine.to_state($"../Walk")
		return


func _state_exited() -> void:
	pass
