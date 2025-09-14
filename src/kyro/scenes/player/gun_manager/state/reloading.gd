extends State


var reload_time:float = 0.0
var amount_to_reload:int = 0


func _state_entered() -> void:
	reload_time = owner.reload_time
	amount_to_reload = get_amount_to_reload()
	owner.animation_reload_requested(reload_time, amount_to_reload)


func _state_process(delta: float) -> void:
	reload_time -= delta
	if reload_time <= 0:
		pass


func _state_exited() -> void:
	owner.clip_ammo += amount_to_reload
	owner.reserve_ammo -= amount_to_reload


func get_amount_to_reload() -> int:
	return mini(owner.clip_size - owner.clip_ammo, owner.reserve_ammo)


func can_reload() -> bool:
	return owner.reserve_ammo > 0 and owner.clip_ammo < owner.clip_size


func reload_wanted() -> bool:
	return Input.is_action_just_pressed(&"reload") or owner.clip_ammo == 0
