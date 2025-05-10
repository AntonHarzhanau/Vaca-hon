extends CanvasLayer

@onready var quit_dialog_panel = $Panel/QuitDialogPanel
@onready var confirm_button = $Panel/QuitDialogPanel/Button_container/ConfirmButton
@onready var cancel_button = $Panel/QuitDialogPanel/Button_container/CancelButton

func _on_confirm_button_pressed() -> void:
	WebSocketClient.close_connection()
	get_tree().change_scene_to_file("res://scenes/Menu/home.tscn")

func _on_cancel_button_pressed() -> void:
	$".".visible = false
