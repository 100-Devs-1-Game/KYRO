extends Camera3D


@export_group("Shake", "shake_")
@export var shake_noise:Noise
@export var shake_trauma_decay:float = 0.8
@export var shake_trauma_max:float = 2
@export var shake_rotation_max:Vector3 = Vector3(PI, PI, 0.0)
@export var shake_offset_max:Vector2 = Vector2(0.05, 0.05)


var time:float
var shake_trauma:float = 0:
	set(new):
		shake_trauma = clampf(new, 0, shake_trauma_max)
var shake_rotation:Vector3


func _process(delta: float) -> void:
	if not is_zero_approx(shake_trauma):
		shake()
		time += delta
		shake_trauma /= 1 + shake_trauma_decay * delta


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
