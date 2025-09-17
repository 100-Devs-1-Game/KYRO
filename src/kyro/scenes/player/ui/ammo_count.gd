extends Control

const INFINITY:String = "∞"

var infinite_reserve:bool = false:
	set(new):
		infinite_reserve = new
		if infinite_reserve:
			reserve_ammo_count.self_modulate = Color(1.0, 1.0, 0.51)
		else:
			reserve_ammo_count.self_modulate = Color(1.0, 1.0, 1.0)
		reserve_ammo = reserve_ammo

var clip_ammo:int:
	set(new):
		clip_ammo = new
		clip_ammo_count.text = "%02d" % new

var reserve_ammo:int:
	set(new):
		reserve_ammo = new
		if infinite_reserve:
			reserve_ammo_count.text = INFINITY
			return
		reserve_ammo_count.text = "%02d" % new


var amount_to_reload:int = 12


@onready var clip_ammo_count:Label = %ClipAmmoCount
@onready var reserve_ammo_count:Label = %ReserveAmmoCount
@onready var animation_player:AnimationPlayer = $AnimationPlayer


func shoot() -> void:
	animation_player.play(&"Shoot")


func reload() -> void:
	animation_player.play(&"Reload")


func count_reserve_into_clip(duration:float) -> void:
	var tween:Tween = create_tween()
	
	tween.tween_property(self, ^"reserve_ammo", -amount_to_reload, duration).as_relative()
	tween.parallel().tween_property(self, ^"clip_ammo", amount_to_reload, duration).as_relative()
