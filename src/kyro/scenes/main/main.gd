extends Node3D


var level_packed:PackedScene
var level:Node


@onready var main_menu:CanvasLayer = $MainMenu


func _on_player_restart_requested() -> void:
	pass


func _on_player_to_menu_requested() -> void:
	pass


func _on_main_menu_play_level_requested(level_path: String) -> void:
	to_level(load(level_path))
	main_menu.visible = false


func to_level(p_level_packed:PackedScene) -> void:
	level_packed = p_level_packed
	if is_instance_valid(level):
		remove_child(level)
		level.queue_free()
	level = level_packed.instantiate()
	add_child(level)
