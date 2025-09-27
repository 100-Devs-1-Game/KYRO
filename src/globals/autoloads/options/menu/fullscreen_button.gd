extends CheckButton

func _toggled(toggled_on: bool) -> void:
	if toggled_on:
		OptionsManager.current.window_mode = DisplayServer.WINDOW_MODE_FULLSCREEN
	else:
		OptionsManager.current.window_mode = DisplayServer.WINDOW_MODE_WINDOWED
