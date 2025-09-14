extends State

@export_group("State Connectons", "state_")
@export var state_jump:State
@export var state_crouch:State


func _state_entered() -> void:
	pass


func _state_process(delta: float) -> void:
	pass


func _state_physics_process(delta: float) -> void:
	if state_jump.jumpswitch():
		return
	if state_crouch.crouchswitch():
		return
	
	owner.do_damping(delta)
	owner.do_forward_movement(delta)
	owner.do_strafe_movement(delta)
	owner.do_gravity(delta)
	
	owner.move_and_slide()
	state_jump.do_coyote_time(delta)
	
	owner.do_post_slide_updates()
	
	var modal_basic:State = owner.get_modal_basic_state()
	if modal_basic != self:
		machine.to_state(modal_basic)


func _state_exited() -> void:
	pass
