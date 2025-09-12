extends State


func _state_entered() -> void:
	pass


func _state_process(delta: float) -> void:
	pass


func _state_physics_process(delta: float) -> void:
	if Input.is_action_just_released("ui_accept"):
		var falling:State = $"../Falling"
		owner.velocity.y /= 2.0
		machine.to_state(falling)
		falling._state_physics_process(delta)
		return
	
	owner.do_forward_movement(delta)
	owner.do_strafe_movement(delta)
	owner.do_damping(delta)
	owner.do_gravity(delta)
	
	owner.move_and_slide()
	owner.do_coyote_time(delta)
	
	owner.do_post_slide_updates()
	
	if owner.can_wallride():
		machine.to_state($"../Wallride")
	
	if owner.is_on_floor():
		machine.to_state($"../Walk")
		return
	elif owner.velocity.y < 0:
		machine.to_state($"../Falling")


func _state_exited() -> void:
	pass


func jump() -> void:
	owner.jump_coyote_time = 0
	owner.velocity.y = owner.jump_strength
	machine.to_state(self)
