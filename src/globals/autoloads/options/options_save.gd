class_name OptionsSave
extends Resource
## Saves options for easy referencing

const MAXIMUM_LOOK_SENSITIVITY:float = 1 / PI / 30

var do_apply:bool


#region Gameplay
@export_group("Gameplay")
@export_range(0.05, 1.0, 0.01) var look_sensitivity:float = 0.5
@export_custom(PROPERTY_HINT_RANGE, "-1,1,0.1") var look_sensitivity_vector:Vector2 = Vector2.ONE
#endregion Gameplay

#region Video
@export_group("Video")
## Mode of the main window.
@export var window_mode:DisplayServer.WindowMode = DisplayServer.WINDOW_MODE_WINDOWED:
	set(new):
		window_mode = new
		if do_apply:
			_apply_window_mode()
#endregion Video

#region Audio
@export_group("Audio")
## Linear volumes of busses.
var _bus_volumes:Dictionary[int,float] = {}
#endregion Audio


func set_bus_volume(bus_index:int, linear_volume:float) -> void:
	assert(bus_index in _bus_volumes, "bus index '0' does not already exist in bus volumes!")
	_bus_volumes[bus_index] = linear_volume


func sensitivity_multiply(vector:Vector2) -> Vector2:
	return vector * look_sensitivity_vector * (look_sensitivity * MAXIMUM_LOOK_SENSITIVITY)


func apply_settings() -> void:
	_apply_window_mode()
	_apply_bus_volumes()


func _apply_window_mode() -> void:
	DisplayServer.window_set_mode(window_mode)


func _apply_bus_volumes() -> void:
	for bus_index in _bus_volumes:
		AudioServer.set_bus_volume_linear(bus_index, _bus_volumes[bus_index])
