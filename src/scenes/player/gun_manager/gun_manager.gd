extends Node


signal ammo_counts_updated()

signal animation_reload_requested(duration:float, reload_amount:int)
signal animation_shoot_requested(duration:float)


@export_group("Stats")
@export var fire_rate:float = 2.0
@export_range(0, 99) var clip_size:int = 12
# NOTE: Not implemented properly. Keep at 1.4
@export var reload_time:float = 1.4
@export var damage:int = 50

@export_group("Nodes")
@export var raycast:RayCast3D


var clip_ammo:int = clip_size
var reserve_ammo:int = 1


@onready var state_machine:StateMachine = $StateMachine
@onready var gunshot_player:AudioStreamPlayer = $GunshotPlayer


func load_data(data:GunData) -> void:
	mirror_metadata(&"fire_rate", data)
	mirror_metadata(&"clip_size", data)
	mirror_metadata(&"reload_time", data)
	mirror_metadata(&"damage", data)
	
	clip_ammo = data.get_meta(&"starting_clip_ammo", 0)
	reserve_ammo = data.get_meta(&"starting_reserve_ammo", 0)


func fire_bullet() -> void:
	raycast.force_raycast_update()
	if raycast.is_colliding() and raycast.get_collider() is Hurtbox:
		raycast.get_collider().take_damage(damage)
	
	var tracer_endpoint:Vector3
	if raycast.is_colliding():
		tracer_endpoint = raycast.get_collision_point()
	else:
		tracer_endpoint = raycast.to_global(raycast.target_position)
	# Awful code but it works
	var tracer:Node3D = raycast.owner.TRACER_SCENE.instantiate()
	raycast.owner.add_sibling(tracer)
	tracer.global_position = raycast.owner.bullet_tracer_point.global_position
	tracer.fire_at(tracer_endpoint)
	gunshot_player.play()


## Sets a property on the GunManager to the value in the Object metadata (if it exists).
func mirror_metadata(property:StringName, object:Object) -> void:
	set(property, object.get_meta(property, get(property)))
