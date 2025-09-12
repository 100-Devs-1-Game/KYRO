extends State


@export var gravity_mod:float = 2.0
@export var strafe_traction_mod:float = 0.4

@export_group("State Connectons", "state_")
@export var state_jump:State


func _state_entered() -> void:
	owner.strafe_traction *= strafe_traction_mod
	print(owner.strafe_traction)


func _state_process(delta: float) -> void:
	pass


func _state_physics_process(delta: float) -> void:
	if state_jump.jumpswitch():
		return
	
	owner.do_forward_movement(delta)
	owner.do_strafe_movement(delta)
	owner.do_damping(delta)
	owner.do_gravity(delta * gravity_mod)
	
	owner.move_and_slide()
	state_jump.do_coyote_time(delta)
	
	owner.do_post_slide_updates()
	
	if owner.is_on_floor():
		machine.to_state($"../Walk")
		return


func _state_exited() -> void:
	owner.strafe_traction /= strafe_traction_mod
	print(owner.strafe_traction)
