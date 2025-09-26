@tool
extends Control


const SEPERATOR:String = "-"
const RANDOM_TEXT_AMOUNT:int = 100

const RANDOM_TEXT_PATH:String = "res://globals/components/random_text_scroll/random_text.txt"


static var random_text:String = ""
static var random_text_size:Vector2 = Vector2(-1, -1)


var child_item:RID

var _tc_font:Font
var _tc_font_size:int


static func _static_init() -> void:
	random_text = ""
	var file := FileAccess.open(RANDOM_TEXT_PATH, FileAccess.READ)
	if file == null:
		push_error("Random text file not found at \"%s\"" % RANDOM_TEXT_PATH)
	
	var snippets:Array[String] = []
	
	while file.get_position() < file.get_length():
		snippets.append(file.get_line())
	
	while len(random_text) < RANDOM_TEXT_AMOUNT:
		random_text += snippets.pop_at(randi() % len(snippets)) + SEPERATOR
	print(random_text)


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_THEME_CHANGED:
			_tc_font = get_theme_font(&"font", &"RandomTextScroll")
			_tc_font_size = get_theme_default_font_size()
			print(_tc_font.get_string_size("A", 0, -1, _tc_font_size))
			random_text_size = _tc_font.get_string_size(random_text, HORIZONTAL_ALIGNMENT_LEFT, -1, _tc_font_size)


func _get_minimum_size() -> Vector2:
	return Vector2(0, random_text_size.y)


func _draw() -> void:
	if not _tc_font:
		print("FONT IN")
		return
	_tc_font.draw_string(get_canvas_item(), 
		Vector2(0, _tc_font_size), random_text, 0, -1, _tc_font_size, Color(len(random_text), 0, 0, 1)
		)
