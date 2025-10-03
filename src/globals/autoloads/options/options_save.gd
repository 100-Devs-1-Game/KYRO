class_name OptionsSave
extends Resource
## Saves options for easy referencing

const MAXIMUM_LOOK_SENSITIVITY:float = 1 / PI / 30


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
#endregion Video

#region Audio
@export_group("Audio")
## Linear volumes of busses.
@export var bus_volumes:Array[float] = [
	1.0,
	0.8
]
#endregion Audio


static func load_config(path:String) -> OptionsSave:
	var instance := OptionsSave.new()
	if not FileAccess.file_exists(path):
		return instance
	
	var file := ConfigFile.new()
	var error := file.load(path)
	
	if error == ERR_FILE_CANT_OPEN:
		push_error("Can't open options config file at \"%s\", returning default options" % path)
		return instance
	
	instance.look_sensitivity = file.get_value("Gameplay", "look_sensitivity", instance.look_sensitivity)
	instance.look_sensitivity_vector = file.get_value(
		"Gameplay", 
		"look_sensitivity_vector", 
		instance.look_sensitivity_vector
	)
	
	instance.window_mode = DisplayServer.WINDOW_MODE_FULLSCREEN if file.get_value(
		"Video", 
		"fullscreen", 
		false
	) else DisplayServer.WINDOW_MODE_WINDOWED
	
	instance._load_bus_volumes_from_config(file)
	return instance


func save_config(path:String) -> void:
	var file:ConfigFile = ConfigFile.new()
	file.set_value("Gameplay", "look_sensitivity", look_sensitivity)
	file.set_value("Gameplay", "look_sensitivity_vector", look_sensitivity_vector)
	
	file.set_value("Video", "fullscreen", window_mode == DisplayServer.WINDOW_MODE_FULLSCREEN)
	
	for bus_idx in len(bus_volumes):
		var bus_name := AudioServer.get_bus_name(bus_idx)
		file.set_value("Audio Volumes", bus_name, bus_volumes[bus_idx])
	
	file.save(path)


func set_bus_volume(bus_index:int, linear_volume:float) -> void:
	assert(len(bus_volumes) > bus_index, "bus index '0' does not already exist in bus volumes!")
	bus_volumes[bus_index] = linear_volume


func sensitivity_multiply(vector:Vector2) -> Vector2:
	return vector * look_sensitivity_vector * (look_sensitivity * MAXIMUM_LOOK_SENSITIVITY)


func apply_settings() -> void:
	_apply_window_mode()
	_apply_bus_volumes()


func _apply_window_mode() -> void:
	DisplayServer.window_set_mode(window_mode)


func _apply_bus_volumes() -> void:
	for bus_index in len(bus_volumes):
		AudioServer.set_bus_volume_linear(bus_index, bus_volumes[bus_index])


func _load_bus_volumes_from_config(file:ConfigFile) -> void:
	if not file.has_section("Audio Volumes"):
		push_error("No Audio Volumes section present in config!")
		return
	
	var bus_names := file.get_section_keys("Audio Volumes")
	for bus_name in bus_names:
		var bus_index := AudioServer.get_bus_index(bus_name)
		if bus_index == -1:
			push_error("Invalid bus name \"%s\" in options config" % bus_name)
			continue
		
		bus_volumes[bus_index] = file.get_value(
			"Audio Volumes", 
			bus_name, 
			bus_volumes[bus_index]
		)
