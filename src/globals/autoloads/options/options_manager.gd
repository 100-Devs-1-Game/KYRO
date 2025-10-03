extends Node


signal options_exited()


const OPTIONS_SAVE_PATH:String = "user://options.cfg"


var current:OptionsSave
## Options duplicate used as a scratchboard for all the settings that are not yet
## applied
var tenative:OptionsSave


@onready var options_menu:Panel = $OptionsMenu


func _init() -> void:
	current = OptionsSave.load_config(OPTIONS_SAVE_PATH)
	current.apply_settings()
	tenative = current.duplicate()


func _on_cancel_pressed() -> void:
	tenative = current.duplicate()
	options_menu.visible = false
	options_exited.emit()


func _on_apply_pressed() -> void:
	current = tenative
	current.apply_settings()
	current.save_config(OPTIONS_SAVE_PATH)
	tenative = current.duplicate()
	options_menu.visible = false
	options_exited.emit()
