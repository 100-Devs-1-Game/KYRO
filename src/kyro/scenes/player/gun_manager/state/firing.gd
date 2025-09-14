extends State

var firing_wanted:bool
var cooldown_time:float = 0.0


func _state_entered() -> void:
	cooldown_time = 1.0 / owner.firing_rate
	owner.animation_shoot_requested(cooldown_time)
	owner.clip_ammo -= 1


func _state_process(delta: float) -> void:
	cooldown_time -= delta
	if cooldown_time <= 0:
		if can_fire() and firing_wanted:
			machine.to_state(self) # funny


func _state_physics_process(delta: float) -> void:
	pass


func _state_exited() -> void:
	pass


func can_fire() -> bool:
	return owner.clip_ammo > 0
