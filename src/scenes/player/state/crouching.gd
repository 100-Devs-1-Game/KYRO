extends State


const SLIDE_MINIMUM_SPEED:float = 8
const SLIDE_COOLDOWN_MAX:float = 0.5


@export var inital_forward_boost:float = 12
@export var slope_forward_boost:float = 26
@export var slide_duration:float = 2.0

@export_group("Modifiers")
@export var forward_speed_mod:float = 0.2
@export var forward_damping_mod:float = 0.2
@export var strafe_speed_mod:float = 0.1
@export var strafe_damping_mod:float = 0.1

@export_group("State Connectons", "state_")
@export var state_jump:State
@export var state_walk:State


var slide_cooldown:float = 0.0


func _state_entered() -> void:
	owner.velocity += owner.state_commons.get_forward_floor_normal() * inital_forward_boost
	owner.forward_damping *= forward_damping_mod
	owner.strafe_damping *= strafe_damping_mod
	owner.animation_player.play(&"crouch_down")


func _process(delta: float) -> void:
	slide_cooldown -= delta


func _state_physics_process(delta: float) -> void:
	if state_jump.jumpswitch():
		return
	
	if not crouch_wanted():
		machine.to_state(state_walk)
		machine.current_state._state_physics_process(delta)
		return
	
	owner.state_commons.do_forward_movement(delta * forward_speed_mod)
	owner.state_commons.do_strafe_movement(delta * strafe_speed_mod)
	owner.state_commons.do_damping(delta)
	owner.state_commons.do_gravity(delta)
	
	var floor_degree:float = Vector3.FORWARD.dot(owner.get_floor_normal())
	owner.velocity += owner.state_commons.get_forward_floor_normal() * floor_degree * slope_forward_boost * delta
	
	owner.move_and_slide()
	state_jump.do_coyote_time(delta)
	
	owner.state_commons.do_post_slide_updates()
	
	if not can_crouch():
		machine.to_state(state_walk)
		return


func _state_exited() -> void:
	if not owner.state_commons.can_uncrouch():
		machine.current_state = owner.state_dying
	
	owner.forward_damping /= forward_damping_mod
	owner.strafe_damping /= strafe_damping_mod
	owner.animation_player.play(&"crouch_up")
	owner.floor_stop_on_slope = true
	slide_cooldown = SLIDE_COOLDOWN_MAX


func crouchswitch() -> bool:
	if can_crouch() and crouch_wanted():
		machine.to_state(self)
		_state_physics_process(get_physics_process_delta_time())
		return true
	return false


func crouch_wanted() -> bool:
	return Input.is_action_pressed(&"crouch")


func can_crouch() -> bool:
	return owner.velocity.z  < -SLIDE_MINIMUM_SPEED and slide_cooldown < 0
