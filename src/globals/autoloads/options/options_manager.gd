extends Node


signal options_exited()


const OPTIONS_SAVE_PATH:String = "user://options.config"


var current:OptionsSave


@onready var options_menu:Panel = $OptionsMenu


func _ready() -> void:
	current = OptionsSave.load_config(OPTIONS_SAVE_PATH)
	current.apply_settings()


func _on_exit_pressed() -> void:
	options_menu.visible = false
	current.apply_settings()
	options_exited.emit()
	current.save_config(OPTIONS_SAVE_PATH)
