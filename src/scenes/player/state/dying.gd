extends State


func _state_entered() -> void:
	owner.hud.visible = false
	owner.game_over.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	owner.animation_player.play(&"dying")
	owner.velocity = Vector3.ZERO


func _state_process(delta: float) -> void:
	pass


func _state_physics_process(delta: float) -> void:
	pass


func _state_exited() -> void:
	pass
