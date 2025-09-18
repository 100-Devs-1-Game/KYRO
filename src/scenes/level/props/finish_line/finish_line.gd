extends Area3D


func _on_body_entered(body: Node3D) -> void:
	body.state_machine.to_state(body.get_node("%Won"))
