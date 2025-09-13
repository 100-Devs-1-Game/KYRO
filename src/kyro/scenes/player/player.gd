extends CharacterBody3D


@export_group("Movement")
@export var forward_speed:float = 10
@export var strafe_speed: float = 12
@export var forward_damping: float = 8.0
@export var strafe_damping: float = 10.0
@export_group("Jumping")
@export var jump_strength: float = 10.0
@export var jump_coyote_max: float = 0.5
@export_group("Wallriding")
@export_range(0, 180, 0.5, "radians_as_degrees") var wallride_angle_tolerance:float = PI/4


## If this is 0, wallriding can't be acheived. Otherwise, this is a the wall that will be clung to
var wallride_axis:float = 0.0
var sensitivity:float = 1 / PI / 60 # TODO: Move this to a GameSettings 

@onready var head:Node3D = %Head
@onready var camera:Camera3D = %Camera3D
@onready var gun_cast:RayCast3D = %GunCast
@onready var arm_animation_player:AnimationPlayer = $Head/Camera3D/Arm/AnimationPlayer
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
		arm_animation_player.play(&"Shoot")
		var collider := gun_cast.get_collider()
		if collider and collider is Hurtbox:
			collider.take_damage(100)
		return


#region State common methods
func do_forward_movement(delta: float) -> void:
	velocity.z -= forward_speed * delta * forward_damping


func do_strafe_movement(delta: float) -> void:
	var axis:float = Input.get_axis(&"ui_left", &"ui_right")
	velocity.x += axis * strafe_speed * delta * strafe_damping


func do_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta


func do_damping(delta: float) -> void:
	velocity.z /= 1 + (forward_damping * delta)
	velocity.x /= 1 + (strafe_damping * delta)


func do_post_slide_updates() -> void:
	wallride_axis = 0
	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)
		var dot := Vector3.LEFT.dot(collision.get_normal())
		if absf(dot) > absf(wallride_axis):
			wallride_axis = dot


func can_wallride() -> bool:
	return abs(wallride_axis * PI) > wallride_angle_tolerance


func get_modal_basic_state() -> State:
	if is_on_floor():
		return state_walk
	if velocity.y > 0:
		return state_jump
	return state_fall
#endregion
