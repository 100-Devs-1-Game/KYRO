extends State

@export var gravity_multiplier:float = 0.2


func _state_entered() -> void:
	pass


func _state_process(delta: float) -> void:
	pass


func _state_physics_process(delta: float) -> void:
	owner.do_forward_movement(delta * 1.2)
	owner.do_strafe_movement(delta)
	owner.do_damping(delta)
	owner.do_gravity(delta * gravity_multiplier)
	
	owner.move_and_slide()
	owner.do_coyote_time(delta)
	
	if not owner.can_wallride():
		var modal_basic:State = owner.get_modal_basic_state()
		machine.to_state(modal_basic)


func _state_exited() -> void:
	pass
