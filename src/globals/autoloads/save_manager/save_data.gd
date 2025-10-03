class_name SaveData
extends Resource


var levels:Array[LevelSaveData]


static func load(path:String) -> void:
	pass


func save(path:String) -> void:
	var file := FileAccess.open(path, FileAccess.WRITE)
	file.store_8(len(levels))
	for level in levels:
		level.serialize(file)
