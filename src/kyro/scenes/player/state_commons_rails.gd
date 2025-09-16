extends "res://scenes/player/state_commons.gd"

const RAIL_TRAVERSE_DURATION:float = 0.2

var rail_spacing:float = 2.5
var current_rail:int = 0
var wanted_rail:int = 0
var rail_transition_elapsed:float = 0.0


func do_strafe_movement(delta: float) -> void:
	if wanted_rail == current_rail:
		rail_transition_elapsed = 0.0
		owner.velocity.x = 0
		wanted_rail = current_rail + Input.get_axis(&"ui_left", &"ui_right")
	if wanted_rail == current_rail:
		return
	
	rail_transition_elapsed = minf(rail_transition_elapsed + delta, RAIL_TRAVERSE_DURATION)
	
	if rail_transition_elapsed == RAIL_TRAVERSE_DURATION:
		owner.position.x = wanted_rail * rail_spacing
		owner.velocity.x = 0
		current_rail = wanted_rail
		rail_transition_elapsed = 0.0
		return
	
	owner.velocity.x = (Tween.interpolate_value(
		current_rail * rail_spacing, (wanted_rail - current_rail) * rail_spacing, rail_transition_elapsed,
		RAIL_TRAVERSE_DURATION, Tween.TRANS_QUAD, Tween.EASE_OUT
	) - owner.global_position.x) / delta


func do_damping(delta: float) -> void:
	owner.velocity.z /= 1 + (owner.forward_damping * delta)
