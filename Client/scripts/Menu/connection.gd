extends Control


func _on_connecter_pressed() -> void:
	var scene = load("res://scenes/Menu/home.tscn")
	if scene:
		get_tree().change_scene_to_file("res://scenes/Menu/home.tscn")



func _on_creer_pressed() -> void:
	var scene = load("res://scenes/Menu/Cree_compte.tscn")
	if scene:
		get_tree().change_scene_to_file("res://scenes/Menu/Cree_compte.tscn")
