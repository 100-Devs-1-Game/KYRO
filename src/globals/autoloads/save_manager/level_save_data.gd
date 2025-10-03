class_name LevelSaveData
extends Resource


var best_time:float = -1.0
var collectibles:int = 0


static func deserialize(file:FileAccess) -> LevelSaveData:
	var instance := LevelSaveData.new()
	instance.best_time = file.get_float()
	instance.collectibles = file.get_8()
	return instance


## Returns if this level was beaten
func get_is_beat() -> bool:
	return best_time > 0


func serialize(file:FileAccess) -> void:
	file.store_float(best_time)
	file.store_8(collectibles)
