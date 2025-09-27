extends GridContainer

const AUDIO_SLIDER:PackedScene = preload("uid://dt02v7n4ecwhq")

@export var sliders:PackedStringArray 


func _ready() -> void:
	for bus in AudioServer.bus_count:
		var bus_name:String = AudioServer.get_bus_name(bus)
		make_audio_slider(bus_name, bus)


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_VISIBILITY_CHANGED:
			_update_bus_volumes()


func make_audio_slider(bus_name:String, bus_index:int) -> void:
	var label := Label.new()
	label.name = bus_name
	label.text = bus_name
	add_child(label)
	var audio_slider:HSlider = AUDIO_SLIDER.instantiate()
	audio_slider.value = AudioServer.get_bus_volume_linear(bus_index)
	audio_slider.name = bus_name + "Slider"
	audio_slider.value_changed.connect(_set_bus_volume.bind(bus_index))
	add_child(audio_slider)


func _update_bus_volumes() -> void:
	for bus in AudioServer.bus_count:
		var slider:HSlider = get_child((bus+1)*2-1)
		slider.set_block_signals(true)
		slider.value = AudioServer.get_bus_volume_linear(bus)
		slider.set_block_signals(false)


func _set_bus_volume(value:float, bus_index:int) -> void:
	OptionsManager.current.set_bus_volume(bus_index, value)
