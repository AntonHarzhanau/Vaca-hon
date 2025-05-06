extends Control


func _on_creer_pressed() -> void:
	var scene = load("res://scenes/Menu/Connection.tscn")
	if scene:
		get_tree().change_scene_to_file("res://scenes/Menu/home.tscn")


func _on_texture_button_pressed() -> void:
	var scene = load("res://scenes/Menu/home.tscn")
	if scene:
		get_tree().change_scene_to_file("res://scenes/Menu/home.tscn")
