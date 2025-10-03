extends OptionButton

@export var property:StringName


func _init() -> void:
	item_selected.connect(_on_item_selected)


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_VISIBILITY_CHANGED:
			var value:int = OptionsManager.tenative.get(property)
			selected = get_item_index(value)


func _on_item_selected(index:int) -> void:
	OptionsManager.tenative.set(property, get_item_id(index))
