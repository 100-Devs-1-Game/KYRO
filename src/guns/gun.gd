class_name Gun
extends Node3D

@export var animation_player: AnimationPlayer


func _ready() -> void:
	assert(animation_player)


func shoot():
	animation_player.play("shoot")
