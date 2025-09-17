extends Node3D


@onready var tracer_mesh:MeshInstance3D = $TracerMesh

var tracer_tween:Tween


func fire_at(point:Vector3) -> void:
	look_at(point)
	if tracer_tween and tracer_tween.is_valid() and tracer_tween.is_running():
		tracer_tween.stop()
	tracer_tween = create_tween()
	tracer_tween.tween_method(
		_update_tracer_mesh_param.bind(&"tracer_thickness"),
		0.2, 1.0, 0.05
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tracer_tween.tween_method(
		_update_tracer_mesh_param.bind(&"tracer_thickness"),
		1.0, 0.0, 0.35
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tracer_tween.tween_callback(queue_free)


func _update_tracer_mesh_param(value:Variant, param:StringName) -> void:
	(tracer_mesh.mesh.material as ShaderMaterial).set_shader_parameter(param, value)
