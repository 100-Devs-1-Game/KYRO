extends State


@export var gravity_mod:float = 2.0
@export var strafe_damping_mod:float = 0.4

@export_group("State Connectons", "state_")
@export var state_jump:State


func _state_entered() -> void:
	owner.strafe_damping *= strafe_damping_mod
	


func _state_process(delta: float) -> void:
	pass


func _state_physics_process(delta: float) -> void:
	if state_jump.jumpswitch():
		return
	
	owner.state_commons.do_damping(delta)
	owner.state_commons.do_forward_movement(delta)
	owner.state_commons.do_strafe_movement(delta)
	owner.state_commons.do_gravity(delta * gravity_mod)
	
	owner.move_and_slide()
	state_jump.do_coyote_time(delta)
	
	owner.state_commons.do_post_slide_updates()
	
	if owner.is_on_floor():
		machine.to_state($"../Walk")
		return


func _state_exited() -> void:
	owner.strafe_damping /= strafe_damping_mod
	
