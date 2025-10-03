extends CheckBox


@export var property:StringName


func _toggled(toggled_on: bool) -> void:
	OptionsManager.current.set(property, toggled_on)


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_VISIBILITY_CHANGED:
			button_pressed = OptionsManager.current.get(property)
