extends Camera3D


@export_group("Shake", "shake_")
@export var shake_noise:Noise
@export var shake_trauma_decay:float = 0.8
@export var shake_trauma_max:float = 2
@export var shake_rotation_max:Vector3 = Vector3(PI, PI, 0.0)
@export var shake_offset_max:Vector2 = Vector2(0.05, 0.05)
@export_group("Fov effect", "fov_")
## The maximum that the effect approaches
@export_range(0.0, 179.0, 0.1, "suffix:°") var fov_effect_increase:float = 25.0
## How fast the effect ramps to maximum
@export var fov_effect_exp:float = 1.1
@export var fov_effect_start:float = 15
@export var fov_effect_speed:float = 17



var base_fov:float
var target_fov:float

var time:float
var shake_trauma:float = 0:
	set(new):
		shake_trauma = clampf(new, 0, shake_trauma_max)
var shake_rotation:Vector3


func _ready() -> void:
	base_fov = fov


func _process(delta: float) -> void:
	if not is_zero_approx(shake_trauma):
		shake()
		time += delta
		shake_trauma /= 1 + shake_trauma_decay * delta
	_recalculate_fov_effect()
	print((owner.velocity).dot(-owner.global_basis.z))
	fov = lerpf(fov, target_fov, delta * fov_effect_speed)


func _recalculate_fov_effect() -> void:
	var forward_speed_normalized:float = \
			(owner.velocity).dot(-owner.global_basis.z)
	forward_speed_normalized = minf(-forward_speed_normalized + fov_effect_start, 0.0)
	
	target_fov = base_fov + (-fov_effect_exp ** (forward_speed_normalized)) \
			* fov_effect_increase + fov_effect_increase


func shake():
	var amount:float = shake_trauma / shake_trauma_max
	rotation -= shake_rotation
	shake_rotation =  shake_rotation_max * amount \
			* Vector3(
				shake_noise.get_noise_2d(time, 0.0),
				shake_noise.get_noise_2d(time, 6.0),
				shake_noise.get_noise_2d(time, 12.0)
			)
	rotation += shake_rotation
	h_offset = shake_offset_max.x * amount * shake_noise.get_noise_2d(time, 18.0)
	v_offset = shake_offset_max.x * amount * shake_noise.get_noise_2d(time, 24.0)
