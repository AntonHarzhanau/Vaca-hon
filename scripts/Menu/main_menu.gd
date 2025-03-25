extends Control
@onready var start_btn: Button = $ColorRect/VBoxContainer/Start
@onready var exit_btn: Button = $ColorRect/VBoxContainer/Exit



func _on_start_pressed() -> void:
	States.is_test = false
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_test_pressed() -> void:
	States.is_test = true
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_create_lobby_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Menu/create_lobby.tscn")

func _on_join_lobby_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Menu/list_lobby.tscn")
