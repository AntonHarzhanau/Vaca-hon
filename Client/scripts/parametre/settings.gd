extends Control

@onready var quit_dialog_panel = $QuitDialogPanel

func _ready():
	quit_dialog_panel.visible = false


func _on_close_button_pressed() -> void:
	quit_dialog_panel.visible = false

	pass # Replace with function body.


func _on_parametre_pressed() -> void:
	quit_dialog_panel.visible = true

	pass # Replace with function body.
