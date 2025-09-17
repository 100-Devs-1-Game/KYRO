extends Node3D


var level_packed:PackedScene
var level:Node


@onready var main_menu:CanvasLayer = $MainMenu


func _on_player_restart_requested() -> void:
	to_level(level_packed) # This sucks but it'll work


func _on_player_to_menu_requested() -> void:
	if is_instance_valid(level):
		remove_child(level)
		level.queue_free()
	main_menu.visible = true
	MusicManager.song_request(&"Main Menu")


func _on_main_menu_play_level_requested(level_path: String) -> void:
	to_level(load(level_path))
	main_menu.visible = false
	MusicManager.song_request(&"Tesserakt")


func to_level(p_level_packed:PackedScene) -> void:
	if is_instance_valid(Player.instance):
		Player.instance.restart_requested.disconnect(_on_player_restart_requested)
		Player.instance.to_menu_requested.disconnect(_on_player_to_menu_requested)
	level_packed = p_level_packed
	if is_instance_valid(level):
		remove_child(level)
		level.queue_free()
	level = level_packed.instantiate()
	add_child(level)
	if Player.instance:
		Player.instance.restart_requested.connect(_on_player_restart_requested)
		Player.instance.to_menu_requested.connect(_on_player_to_menu_requested)
