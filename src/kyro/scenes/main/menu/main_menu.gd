extends CanvasLayer


signal play_level_requested(level_path:String)


const LEVEL_BUTTON_SCENE:PackedScene = preload("res://scenes/main/menu/level_button.tscn")


@export var levels:Array[LevelData] = []


@onready var menu_buttons:Control = %Buttons
@onready var level_buttons:Control = %Levels


func _ready() -> void:
	make_level_buttons()


func make_level_buttons() -> void:
	for level in levels:
		var instance := LEVEL_BUTTON_SCENE.instantiate()
		level_buttons.add_child(instance)
		instance.text = level.level_name
		instance.pressed.connect(play_level_requested.emit.bind(level.level_path))


func _on_select_level_pressed() -> void:
	menu_buttons.visible = false
	level_buttons.visible = true


func _on_quit_pressed() -> void:
	get_tree().quit()
