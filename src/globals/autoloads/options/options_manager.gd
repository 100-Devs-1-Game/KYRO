extends Node


signal options_exited()


var current:OptionsSave = preload("uid://b5pekathdrll8").duplicate()


@onready var options_menu:Panel = $OptionsMenu


func _ready() -> void:
	current.apply_settings()


func _on_exit_pressed() -> void:
	options_menu.visible = false
	current.apply_settings()
	options_exited.emit()
