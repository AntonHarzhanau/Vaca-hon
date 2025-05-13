extends Control

@onready var code = $TextureRect/Panel/VBoxContainer/CODE
@onready var email = $TextureRect/Panel/VBoxContainer/EMAIL
@onready var notif = $TextureRect/Panel/VBoxContainer/Label

func _on_confirm_pressed() -> void:
	var payload = {
	"email": email.text, 
	"confirm_code": code.text
	}
	var response = await HttpRequestClient.__post("/Users/confirm", payload)
	print(response)
	
	if response.response_code == 200:
		notif.text ="✅ Compte confirmé avec succès !"
		notif.modulate = Color(0, 1, 0)
	else:
		notif.text = "❌ Code invalide ou email incorrect."
		notif.modulate = Color(1, 0, 0)
	
func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Menu/Connection.tscn")
