extends State
## Rising jump state for player.

@export var damping_delta_mod:float = 1.0
@export var forward_damping_mod:float = 0.5
@export var strafe_damping_mod:float = 0.3

@export_group("State Connectons", "state_")
@export var state_walk:State
@export var state_wallride:State
@export var state_fall:State


var jump_coyote_time:float = 0.0


func _state_entered() -> void:
	owner.strafe_damping *= strafe_damping_mod
	
	owner.forward_damping *= forward_damping_mod


func _state_process(delta: float) -> void:
	pass


func _state_physics_process(delta: float) -> void:
	if Input.is_action_just_released("ui_accept"):
		owner.velocity = owner.state_commons.dampen_vector_axis(owner.velocity, owner.global_basis.y, 2.0)
		machine.to_state(state_fall)
		state_fall._state_physics_process(delta)
		return
	
	owner.state_commons.do_damping(delta * damping_delta_mod)
	owner.state_commons.do_forward_movement(delta)
	owner.state_commons.do_strafe_movement(delta)
	owner.state_commons.do_gravity(delta)
	
	owner.move_and_slide()
	do_coyote_time(delta)
	
	owner.state_commons.do_post_slide_updates(delta)
	
	if owner.state_commons.can_wallride():
		machine.to_state(state_wallride)
	
	if owner.is_on_floor():
		machine.to_state(state_walk)
		return
	elif owner.state_commons.get_vector_axis_value(owner.velocity, owner.global_basis.y) < 0:
		machine.to_state(state_fall)


func _state_exited() -> void:
	owner.strafe_damping /= strafe_damping_mod
	owner.forward_damping /= forward_damping_mod


func do_coyote_time(delta:float) -> void:
	if owner.is_on_floor():
		jump_coyote_time = owner.jump_coyote_max
		return
	jump_coyote_time -= delta


## If jump is wanted and the player is able, will switch to jump state, do the jump physics
## process step immediately, and return true. Should be used as:
## [codeblock]
## func _state_physics_process(delta: float) -> void:
##     if jump_state.do_jumpswitch():
##         return
## [/codeblock]
## See [method can_jump], [method jump_wanted], and [method jump].
func jumpswitch() -> bool:
	if can_jump() and jump_wanted():
		jump()
		machine.to_state(self)
		 # this is bad practice but I don't really care
		_state_physics_process(get_physics_process_delta_time())
		return true
	return false


## If the player can jump
func can_jump() -> bool:
	return jump_coyote_time > 0.0


## If the player is trying to jump
func jump_wanted() -> bool:
	return Input.is_action_just_pressed("ui_accept")


## Performs a standard jump
func jump() -> void:
	jump_coyote_time = 0
	owner.velocity = \
	owner.state_commons.set_vector_axis(
		owner.velocity, owner.global_basis.y, owner.jump_strength)
	machine.to_state(self)
