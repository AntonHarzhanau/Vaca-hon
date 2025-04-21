extends CanvasLayer

class_name EventCard

@onready var descripton: Label = $Background/MarginContainer/VBoxContainer/Description



func _on_close_btn_pressed() -> void:
	self.visible = false
