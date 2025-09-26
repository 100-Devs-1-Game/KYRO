extends CanvasLayer


signal play_level_requested(level_path:String)


enum MenuMode {
	BUTTONS,
	LEVEL_SELECT,
	OPTIONS,
}


const LEVEL_BUTTON_SCENE:PackedScene = preload("res://scenes/main/menu/level_button.tscn")


@export var levels:Array[LevelData] = []


var menu_mode:MenuMode = MenuMode.BUTTONS:
	set(new):
		menu_mode = new
		for i in len(menus):
			menus[i].visible = i == menu_mode


@onready var menu_buttons:Control = %Buttons
@onready var level_buttons:Control = %Levels
@onready var menus:Array[Control] = [menu_buttons, level_buttons]


func _ready() -> void:
	make_level_buttons()
	menu_mode = menu_mode


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action(&"ui_cancel"):
		if menu_mode != MenuMode.BUTTONS:
			menu_mode = MenuMode.BUTTONS


func make_level_buttons() -> void:
	for level in levels:
		var instance := LEVEL_BUTTON_SCENE.instantiate()
		level_buttons.add_child(instance)
		instance.text = level.level_name
		instance.pressed.connect(play_level_requested.emit.bind(level.level_path))


func reset() -> void:
	menu_mode = MenuMode.BUTTONS

func _on_select_level_pressed() -> void:
	menu_mode = MenuMode.LEVEL_SELECT


func _on_quit_pressed() -> void:
	get_tree().quit()
