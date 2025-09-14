extends Node


signal ammo_counts_updated()

signal animation_reload_requested(duration:float, reload_amount:int)
signal animation_shoot_requested(duration:float)


@export var fire_rate:float = 1.0
@export_range(0, 99) var clip_size:int = 12
# NOTE: Not implemented properly. Keep at 1.4
@export var reload_time:float = 1.4


var clip_ammo:int = clip_size - 1
var reserve_ammo:int = 1


@onready var state_machine:StateMachine = $StateMachine
