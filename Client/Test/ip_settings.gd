extends Control

@onready var host_edit: TextEdit = $Panel/MarginContainer/VBoxContainer/HostEdit
@onready var port_edit: TextEdit = $Panel/MarginContainer/VBoxContainer/PortEdit

func _ready() -> void:
	host_edit.text = States.HOST
	port_edit.text = States.PORT

func _on_cancel_button_pressed() -> void:
	var scene = load("res://scenes/Menu/Connection.tscn")
	if scene:
		get_tree().change_scene_to_file("res://scenes/Menu/Connection.tscn")


func _on_save_button_pressed() -> void:
	States.set_addres(host_edit.text, port_edit.text)
	print(States.HTTP_BASE_URL)
	print(States.WS_BASE_URL)
	var scene = load("res://scenes/Menu/Connection.tscn")
	if scene:
		get_tree().change_scene_to_file("res://scenes/Menu/Connection.tscn")
