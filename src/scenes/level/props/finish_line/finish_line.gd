extends PickupArea


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_picked_up(by: Node) -> void:
	by.state_machine.to_state(by.get_node("%Won"))
