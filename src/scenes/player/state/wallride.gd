extends State

const WALLRIDE_CAMERA_ROLL:float = PI/54


@export var forward_speed_mod:float = 1.2
@export var gravity_mod:float = 0.2
@export var mod_decay_curve:Curve # TODO: this should probably be baked
@export var jump_impulse:float = 30
@export var jump_forward_impulse:float = 8
@export var wallride_coyote_time_max:float = 0.30

@export_group("State Connectons", "state_")
@export var state_jump:State
@export var state_walk:State


var wallride_time:float = 0.0
var wallride_coyote_time:float = 0.0
var wallride_axis:float


func _state_entered() -> void:
	wallride_time = 0
	wallride_coyote_time = 0
	owner.velocity = owner.state_commons.dampen_vector_axis(owner.velocity, owner.global_basis.y, 1.5)


func _state_process(delta: float) -> void:
	owner.camera.rotation.z = -roundf(owner.wallride_axis) * WALLRIDE_CAMERA_ROLL


func _state_physics_process(delta: float) -> void:
	if owner.state_commons.can_wallride():
		wallride_axis = owner.wallride_axis
	
	if state_jump.jump_wanted():
		owner.velocity = owner.state_commons.set_vector_axis(
			owner.velocity, 
			owner.global_basis.x, 
			jump_impulse * roundf(wallride_axis)
		)
		owner.velocity = owner.state_commons.set_vector_axis(
			owner.velocity,
			-owner.global_basis.z,
			jump_forward_impulse + owner.state_commons.get_vector_axis_value(owner.velocity, -owner.global_basis.z)
		)
		state_jump.jump()
		return
	
	var decay:float = mod_decay_curve.sample(wallride_time)
	
	
	owner.state_commons.do_forward_movement(delta * remap(decay, 0, 1, 1, forward_speed_mod,))
	owner.state_commons.do_strafe_movement(delta)
	owner.state_commons.do_damping(delta)
	owner.state_commons.do_gravity(delta * remap(decay, 0, 1, 1, gravity_mod))
	
	owner.move_and_slide()
	
	owner.state_commons.do_post_slide_updates(delta)
	
	wallride_time += delta
	
	
	if owner.is_on_floor():
		machine.to_state(state_walk)
	
	if not owner.state_commons.can_wallride():
		wallride_coyote_time += delta
		if wallride_coyote_time > wallride_coyote_time_max:
			machine.to_state(owner.state_commons.get_modal_basic_state())


func _state_exited() -> void:
	owner.camera.owner.camera.rotation.z = 0
