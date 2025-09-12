extends State

@export var forward_speed_multiplier:float = 1.2
@export var gravity_multiplier:float = 0.2
@export var jump_impulse:float = 30

@export_group("State Connectons", "state_")
@export var state_jump:State


func _state_entered() -> void:
	owner.forward_speed *= forward_speed_multiplier


func _state_process(delta: float) -> void:
	pass


func _state_physics_process(delta: float) -> void:
	if state_jump.jump_wanted():
		owner.velocity.x = jump_impulse * -roundf(owner.wallride_axis)
		state_jump.jump()
		return
	
	owner.do_forward_movement(delta)
	owner.do_strafe_movement(delta)
	owner.do_damping(delta)
	owner.do_gravity(delta * gravity_multiplier)
	
	owner.move_and_slide()
	
	owner.do_post_slide_updates()
	
	if not owner.can_wallride():
		var modal_basic:State = owner.get_modal_basic_state()
		machine.to_state(modal_basic)


func _state_exited() -> void:
	owner.forward_speed /= forward_speed_multiplier
