extends RefCounted


const FORWARD_NORMAL_THRESHOLD:float = 0.9


var owner:Node


func _init(p_owner:Node) -> void:
	owner = p_owner


func do_forward_movement(delta: float) -> void:
	owner.velocity += get_forward_floor_normal() * owner.forward_speed * delta * owner.forward_damping


func do_strafe_movement(delta: float) -> void:
	var axis:float = Input.get_axis(&"ui_left", &"ui_right")
	owner.velocity.x += axis * owner.strafe_speed * delta * owner.strafe_damping


func do_gravity(delta: float) -> void:
	owner.velocity += owner.get_gravity() * delta


func do_damping(delta: float) -> void:
	owner.velocity.z /= 1 + (owner.forward_damping * delta)
	owner.velocity.x /= 1 + (owner.strafe_damping * delta)


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


## gets the forward-pointing normal parallel to the floor slope. If the player isn't on
## a floor, returns the basis forward instead.
func get_forward_floor_normal() -> Vector3:
	if not owner.is_on_floor():
		return -owner.global_basis.z
	# This sucks and projection is probably technically more correct but I don't. Care.
	var fwd:Vector3 = owner.get_floor_normal().slide(owner.global_basis.x).rotated(owner.global_basis.x, -PI/2)
	return fwd
