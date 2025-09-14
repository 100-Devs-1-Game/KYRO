extends Control


var clip_ammo:int:
	set(new):
		clip_ammo = new
		clip_ammo_count.text = "%02d" % new

var reserve_ammo:int:
	set(new):
		reserve_ammo = new
		reserve_ammo_count.text = "%02d" % new


var amount_to_reload:int = 12


@onready var clip_ammo_count:Label = %ClipAmmoCount
@onready var reserve_ammo_count:Label = %ReserveAmmoCount
@onready var animation_player:AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	clip_ammo = 9
	reserve_ammo = 12


func shoot() -> void:
	animation_player.play(&"Shoot")


func reload() -> void:
	animation_player.play(&"Reload")


func count_reserve_into_clip(duration:float) -> void:
	var tween:Tween = create_tween()
	
	tween.tween_property(self, ^"reserve_ammo", -amount_to_reload, duration).as_relative()
	tween.parallel().tween_property(self, ^"clip_ammo", amount_to_reload, duration).as_relative()
