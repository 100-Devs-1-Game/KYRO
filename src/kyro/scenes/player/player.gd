extends CharacterBody3D

@export_subgroup("Movement")
@export var forward_speed:float = 100
@export var strafe_speed: float = 120
@export var forward_traction: float = 8.0
@export var strafe_traction: float = 10.0
@export_subgroup("Jumping")
@export var jump_strength: float = 10.0
@export var jump_coyote_max: float = 0.5

var jump_coyote_time:float = 0.0
var sensitivity:float = 1 / PI / 60 # TODO: Move this to a GameSettings 

@onready var head:Node3D = %Head
@onready var camera:Camera3D = %Camera3D
@onready var gun_cast:RayCast3D = %GunCast
@onready var wall_run_area:Area3D = %WallRunArea
@onready var state_machine:StateMachine = $StateMachine
@onready var state_walk:State = %Walk
@onready var state_jump:State = %Jumping
@onready var state_fall:State = %Falling


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if not event.keycode == KEY_ESCAPE or not event.pressed: # TODO: Move this to pausemenu behaviour?
			return
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED \
				if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE else Input.MOUSE_MODE_VISIBLE
		get_viewport().set_input_as_handled()
		return
	
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED and event is InputEventMouseMotion:
		head.rotation.y -= event.relative.x * sensitivity
		camera.rotation.x -= event.relative.y * sensitivity
		get_viewport().set_input_as_handled()
		return
	
	if event is InputEventMouseButton:
		if not event.pressed or event.button_index != MOUSE_BUTTON_LEFT:
			return
		gun_cast.force_raycast_update()
		var collider := gun_cast.get_collider()
		if collider and collider is Hurtbox:
			collider.take_damage(100)
		return


#region State common methods
func do_forward_movement(delta: float) -> void:
	velocity.z -= forward_speed * delta 


func do_strafe_movement(delta: float) -> void:
	var axis:float = Input.get_axis(&"ui_left", &"ui_right")
	velocity.x += axis * strafe_speed * delta
	wall_run_area.position.x = axis * 0.4
	print(wall_run_area.position.x)


func do_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta


func do_damping(delta: float) -> void:
	velocity.z /= 1 + (forward_traction * delta)
	velocity.x /= 1 + (strafe_traction * delta)


func do_coyote_time(delta:float) -> void:
	if is_on_floor():
		jump_coyote_time = jump_coyote_max
		return
	jump_coyote_time -= delta


func can_jump() -> bool:
	return jump_coyote_time > 0.0


func can_wallride() -> bool:
	return len(wall_run_area.get_overlapping_bodies()) > 0


func get_modal_basic_state() -> State:
	if is_on_floor():
		return state_walk
	if velocity.y > 0:
		return state_jump
	return state_fall


func jump() -> void: # TODO: Not this
	state_jump.jump()
#endregion
