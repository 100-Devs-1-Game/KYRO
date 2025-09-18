@icon("res://globals/components/state_machine/state_machine.svg")
class_name StateMachine
extends Node
## Manages multiple [State]s and switches between them.


## The default [State] to move to at project start.
@export var default_state:State


## The current [State] of the [StateMachine].
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
	var last_state = current_state # yes this ordering is important, if the last wants
	# to redirect.
	current_state = state
	if last_state:
		last_state._state_exited()
	if current_state:
		current_state._state_entered()
