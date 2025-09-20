extends RefCounted


const FORWARD_NORMAL_THRESHOLD:float = 0.9


var owner:Node


func _init(p_owner:Node) -> void:
	owner = p_owner


func do_forward_movement(delta: float) -> void:
	# DO NOT ASK
	var boost_axis:float = Input.get_axis("ui_down", "ui_up") * owner.boost_speed_modifer
	if boost_axis != 0:
		if owner.boost == 0:
			boost_axis = 0
		owner.boost = max(owner.boost - delta, 0)
	else:
		owner.boost = min(owner.boost + owner.boost_regen * delta, owner.boost_max)
	boost_axis += 1.0
	
	owner.velocity += get_forward_floor_normal() \
			* owner.forward_speed * boost_axis * delta * owner.forward_damping


func do_strafe_movement(delta: float) -> void:
	var axis:float = Input.get_axis(&"ui_left", &"ui_right")
	owner.velocity += owner.global_basis.x * axis * owner.strafe_speed * delta * owner.strafe_damping


func do_gravity(delta: float) -> void:
	owner.velocity += owner.get_gravity() * delta


func do_damping(delta: float) -> void:
	var inp:Vector3 = owner.velocity
	# Forward damp
	owner.velocity = dampen_vector_axis(
			owner.velocity, 
			owner.global_basis.z, 
			1 + owner.forward_damping * delta
	)
	# Sideways damping
	owner.velocity = dampen_vector_axis(
			owner.velocity, 
			owner.global_basis.x, 
			1 + owner.strafe_damping * delta
	)
	if owner.velocity.y != inp.y:
		print("WUH OH")
	
	inp.z /= 1 + (owner.forward_damping * delta)
	inp.x /= 1 + (owner.strafe_damping * delta)
	if not owner.velocity.is_equal_approx(inp):
		print("WUH OH TWO!!")


func do_post_slide_updates() -> void:
	owner.wallride_axis = 0
	for i in owner.get_slide_collision_count():
		var collision: KinematicCollision3D = owner.get_slide_collision(i)
		var dot := Vector3.LEFT.dot(collision.get_normal())
		if absf(dot) > absf(owner.wallride_axis):
			owner.wallride_axis = dot
		dot = Vector3.FORWARD.dot(collision.get_normal())
		if absf(dot) > FORWARD_NORMAL_THRESHOLD:
			owner.state_machine.to_state(owner.state_dying)


func can_wallride() -> bool:
	return abs(owner.wallride_axis * PI) > owner.wallride_angle_tolerance


func get_modal_basic_state() -> State:
	if owner.is_on_floor():
		return owner.state_walk
	if owner.velocity.y > 0:
		return owner.state_jump
	return owner.state_fall


func can_uncrouch() -> bool:
	for c:RayCast3D in owner.uncrouch_check_rays:
		c.force_update_transform()
		c.force_raycast_update()
		if c.is_colliding():
			return false
	return true


## Dampens a target axis from the given vector by the damp amount, then returns the modified damped
## Vector.
func dampen_vector_axis(vector:Vector3, axis:Vector3, damp:float) -> Vector3:
	var dampened := vector.project(axis) / damp
	vector -= vector.project(axis) - dampened # subtract the difference between the two vectors
	return vector


## Sets a vector axis to the value and returns the result.
func set_vector_axis(vector:Vector3, axis:Vector3, value:float) -> Vector3:
	print("")
	vector -= vector.project(axis)
	vector += axis * value
	return vector

## Sets a vector axis to the value and returns the result.
func get_vector_axis(vector:Vector3, axis:Vector3, value:float) -> Vector3:
	return vector.project(axis)


## gets the forward-pointing normal parallel to the floor slope. If the player isn't on
## a floor, returns the basis forward instead.
func get_forward_floor_normal() -> Vector3:
	if not owner.is_on_floor():
		return -owner.global_basis.z
	# This sucks and projection is probably technically more correct but I don't. Care.
	var fwd:Vector3 = owner.get_floor_normal().slide(owner.global_basis.x).rotated(owner.global_basis.x, -PI/2)
	return fwd
