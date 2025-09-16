class_name Player
extends CharacterBody3D


signal restart_requested()
signal to_menu_requested()


const TRACER_SCENE:PackedScene = preload("res://scenes/gun/tracer/bullet_tracer.tscn")


## Singleton instance
static var instance:Player


@export_group("Movement")
@export var forward_speed:float = 10
@export var strafe_speed: float = 12
@export var forward_damping: float = 8.0
@export var strafe_damping: float = 10.0
@export var on_rails:bool = true

@export_group("Jumping")
@export var jump_strength: float = 10.0
@export var jump_coyote_max: float = 0.5
@export_group("Wallriding")
@export_range(0, 180, 0.5, "radians_as_degrees") var wallride_angle_tolerance:float = PI/4
@export_group("Gun")
@export_range(0, 99) var clip_size:int = 12


## If this is 0, wallriding can't be acheived. Otherwise, this is a the wall that will be clung to
var wallride_axis:float = 0.0
var sensitivity:float = 1 / PI / 60 # TODO: Move this to a GameSettings 
var gun_manager:Node:
	set(new):
		if gun_manager:
			gun_manager.ammo_counts_updated.disconnect(_update_ammo_count)
			gun_manager.animation_reload_requested.disconnect(_on_gun_manager_animation_reload_requested)
			gun_manager.animation_shoot_requested.disconnect(_on_gun_manager_animation_shoot_requested)
		gun_manager = new
		if gun_manager:
			gun_manager.ammo_counts_updated.connect(_update_ammo_count)
			gun_manager.animation_reload_requested.connect(_on_gun_manager_animation_reload_requested)
			gun_manager.animation_shoot_requested.connect(_on_gun_manager_animation_shoot_requested)
			_update_ammo_count()
var bullet_tracer_point:Marker3D


@onready var head:Node3D = %Head
@onready var camera:Camera3D = %Camera3D
@onready var gun_cast:RayCast3D = %GunCast
@onready var gun_attach_point:Marker3D = %GunAttachPoint

@onready var hud:CanvasLayer = %Hud
@onready var ammo_count:Control = %AmmoCount
@onready var game_over:CanvasLayer = %GameOver

@onready var arm_animation_player:AnimationPlayer = $Head/Camera3D/Arm/AnimationPlayer
@onready var animation_player:AnimationPlayer = $AnimationPlayer

@onready var state_machine:StateMachine = $StateMachine
@onready var state_commons = %StateCommons
@onready var state_walk:State = %Walk
@onready var state_jump:State = %Jumping
@onready var state_fall:State = %Falling
@onready var state_dying:State = %Dying


func _ready() -> void:
	instance = self
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	_update_ammo_count()


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


func add_gun(data:GunData) -> void:
	gun_manager = data.create_manager(gun_cast)

	var gun_held := data.gun_held.instantiate()
	gun_attach_point.add_child(gun_held)
	bullet_tracer_point = gun_held.get_node(^"%TracerPoint")
	add_child(gun_manager)



func _update_ammo_count() -> void:
	ammo_count.visible = is_instance_valid(gun_manager)
	if not ammo_count.visible:
		return
	ammo_count.clip_ammo = gun_manager.clip_ammo
	ammo_count.reserve_ammo = gun_manager.reserve_ammo


func _on_gun_manager_animation_reload_requested(_duration: float, reload_amount: int) -> void:
	ammo_count.amount_to_reload = reload_amount
	ammo_count.reload()


func _on_gun_manager_animation_shoot_requested(duration: float) -> void:
	arm_animation_player.play(&"Shoot", -1, 
			duration / arm_animation_player.get_animation(&"Shoot").length
	)
	ammo_count.shoot()


func _on_restart_pressed() -> void:
	restart_requested.emit()


func _on_quit_pressed() -> void:
	to_menu_requested.emit()
