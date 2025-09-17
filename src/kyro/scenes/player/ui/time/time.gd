extends Control


var time:float = 0.0:
	set(new):
		time = new
		label.text = "%6.2f" % time
var started:bool = true


@onready var label:Label = $Label


func _process(delta: float) -> void:
	if not started:
		return
	time += delta
