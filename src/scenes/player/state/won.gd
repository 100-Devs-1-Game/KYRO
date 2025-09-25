extends State


func _state_entered() -> void:
	owner.hud.visible = false
	owner.game_over.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	%GameOverLabel.text = "YOU WON"
	%YourTime.text = "YOUR TIME: %6.2f" % %Time.time
	%YourTime.visible = true


func _state_process(delta: float) -> void:
	pass


func _state_physics_process(delta: float) -> void:
	owner.state_commons.do_damping(delta)
	owner.move_and_slide()


func _state_exited() -> void:
	pass
