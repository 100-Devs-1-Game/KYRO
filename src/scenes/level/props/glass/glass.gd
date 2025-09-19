extends Area3D


const GLASS_MAT = preload("res://assets/materials/glass/regular.tres")


func _ready() -> void:
	var collision_shape:CollisionShape3D = get_child(0)
	var mesh:ArrayMesh = collision_shape.shape.get_debug_mesh()
	mesh.surface_set_material(0, GLASS_MAT)
	mesh.surface_set_material(1, GLASS_MAT)
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.mesh = mesh
	mesh_instance.position = collision_shape.position
	add_child(mesh_instance)
	body_entered.connect(_on_body_entered)

func _on_body_entered(body:Player) -> void:
	body.emit_glass()
	queue_free()
