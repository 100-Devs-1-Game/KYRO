extends State


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
	owner.do_gravity(delta)
	
	owner.move_and_slide()
	owner.do_coyote_time(delta)
	
	owner.do_post_slide_updates()
	
	var modal_basic:State = owner.get_modal_basic_state()
	if modal_basic != self:
		machine.to_state(modal_basic)


func _state_exited() -> void:
	pass
