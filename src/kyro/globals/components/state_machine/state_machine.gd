@icon("res://globals/components/state_machine/state_machine.svg")
class_name StateMachine
extends Node


@export var default_state:State


var current_state:State


func _ready() -> void:
	current_state = default_state


func _process(delta: float) -> void:
	if current_state:
		current_state._state_process(delta)


func _physics_process(delta: float) -> void:
	if current_state:
		current_state._state_physics_process(delta)


func to_state(state:State) -> void:
	if current_state:
		current_state._state_exited()
	current_state = state
	if current_state:
		current_state._state_entered()
