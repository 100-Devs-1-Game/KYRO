extends Node


signal animation_reload_requested(duration:float, reload_amount:int)
signal animation_shoot_requested(duration:float)


@export var fire_rate:float = 1.0
@export_range(0, 99) var clip_size:int = 12
@export var reload_time:float = 1.4


var clip_ammo:int = clip_size
var reserve_ammo:int = 0


@onready var state_machine:StateMachine = $StateMachine
@onready var state_idle = %Idle
