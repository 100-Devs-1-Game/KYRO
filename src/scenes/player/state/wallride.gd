extends State

const WALLRIDE_CAMERA_ROLL:float = PI/54

@export var forward_speed_mod:float = 1.2
@export var gravity_mod:float = 0.2
@export var mod_decay_curve:Curve # TODO: this should probably be baked
@export var jump_impulse:float = 30

@export_group("State Connectons", "state_")
@export var state_jump:State


var wallride_time:float = 0.0


func _state_entered() -> void:
	wallride_time = 0
	owner.velocity = owner.state_commons.dampen_vector_axis(owner.velocity, owner.global_basis.y, 1.5)


func _state_process(delta: float) -> void:
	owner.camera.rotation.z = roundf(owner.wallride_axis) * WALLRIDE_CAMERA_ROLL


func _state_physics_process(delta: float) -> void:
	if state_jump.jump_wanted():
		owner.velocity = owner.state_commons.set_vector_axis(
			owner.velocity, 
			owner.global_basis.x, 
			jump_impulse * -roundf(owner.wallride_axis)
		)
		state_jump.jump()
		return
	
	var decay:float = mod_decay_curve.sample(wallride_time)
	
	
	owner.state_commons.do_damping(delta)
	owner.state_commons.do_forward_movement(delta * remap(decay, 0, 1, 1, forward_speed_mod,))
	owner.state_commons.do_strafe_movement(delta)
	owner.state_commons.do_gravity(delta * remap(decay, 0, 1, 1, gravity_mod))
	
	owner.move_and_slide()
	
	owner.state_commons.do_post_slide_updates()
	
	wallride_time += delta
	if not owner.state_commons.can_wallride():
		var modal_basic:State = owner.state_commons.get_modal_basic_state()
		machine.to_state(modal_basic)


func _state_exited() -> void:
	owner.camera.owner.camera.rotation.z = 0
