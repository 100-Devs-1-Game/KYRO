extends Area3D


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body:Player) -> void:
	body.state_machine.to_state(body.state_dying)
