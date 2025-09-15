extends State


func _state_entered() -> void:
	owner.hud.visible = false
	owner.game_over.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	Engine.time_scale = 0.8


func _state_process(delta: float) -> void:
	pass


func _state_physics_process(delta: float) -> void:
	pass


func _state_exited() -> void:
	pass
