extends State
## Rising jump state for player.


var jump_coyote_time:float = 0.0


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
	do_coyote_time(delta)
	
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
	owner.velocity.y = owner.jump_strength
	machine.to_state(self)
