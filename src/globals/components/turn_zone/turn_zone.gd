extends Area3D

## Target rotation of the player
@export var target_rotation:Quaternion
## Restore player rotation on leave
@export var restore_on_leave:bool


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _on_body_entered(body:Player) -> void:
	body.target_rotation = target_rotation


func _on_body_exited(body:Player) -> void:
	body.target_rotation = Quaternion()
