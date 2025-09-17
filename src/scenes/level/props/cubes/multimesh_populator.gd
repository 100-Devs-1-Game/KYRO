extends MultiMeshInstance3D
## Tooling script to populate a space with Multimeshes randomly

@export var extents:Vector3


func _ready() -> void:
	for i in multimesh.instance_count:
		var transform := Transform3D(
			Basis.from_euler(randvec3_range(Vector3.ZERO, Vector3.ONE * TAU)),
			randvec3_range(-extents/2, extents/2)
		)
		multimesh.set_instance_transform(i, transform)
	
	ResourceSaver.save(multimesh, multimesh.resource_path)


func randvec3_range(from:Vector3, to:Vector3) -> Vector3:
	return Vector3(
		randf_range(from.x, to.x), randf_range(from.y, to.y), randf_range(from.z, to.z)
	)
