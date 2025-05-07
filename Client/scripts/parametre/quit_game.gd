extends Control

@onready var quit_dialog_panel = $QuitDialogPanel
@onready var confirm_button = $Back_ground/Button_container/ConfirmButton
@onready var cancel_button = $Back_ground/Button_container/CancelButton

func _ready():
	quit_dialog_panel.visible = false


func _on_quit_button_pressed() -> void:
	quit_dialog_panel.visible = true

	pass # Replace with function body.


func _on_confirm_button_pressed() -> void:
	get_tree().quit() # Ou change_scene_to_file("res://scenes/LoginPage.tscn")

	pass # Replace with function body.


func _on_cancel_button_pressed() -> void:
	quit_dialog_panel.visible = false

	pass # Replace with function body.


func _on_close_button_pressed() -> void:
	quit_dialog_panel.visible = false
	
	pass # Replace with function body.


func _on_exit_pressed() -> void:
	quit_dialog_panel.visible = true

	pass # Replace with function body.
