extends Control

@onready var quit_dialog_panel = $QuitDialogPanel
@onready var confirm_button = $Back_ground/Button_container/ConfirmButton
@onready var cancel_button = $Back_ground/Button_container/CancelButton

func _on_confirm_button_pressed() -> void:
	WebSocketClient.close_connection()
	get_tree().change_scene_to_file("res://scenes/Menu/home.tscn")

func _on_cancel_button_pressed() -> void:
	$".".visible = false
