@icon("res://globals/components/health_component/health.svg")
class_name HealthComponent
extends Node


signal health_depleted()


@export var max_health:int = 100


var health:int = max_health


func take_damage(damage:int) -> void:
	health -= damage
	if health <= 0:
		health_depleted.emit()
