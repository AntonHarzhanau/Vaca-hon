extends Control

@onready var code = $Main/Panel/VBoxContainer/CODE
@onready var notif = $Main/Panel/VBoxContainer/Label

func _ready() -> void:
	notif.text = "Votre compte n'est pas activé. Veuillez entrer le code qui vous a été envoyé par mail."
	notif.modulate = Color(0, 0, 1)

func _on_confirm_pressed() -> void:
	var payload = {
	"id": UserData.user_id, 
	"confirm_code": code.text
	}
	var response = await HttpRequestClient.__post("/Users/confirm", payload)
	print(response)
	
	if response.response_code == 200:
		UserData.is_active = response.body["is_active"]
		notif.text ="✅ Compte confirmé avec succès !"
		notif.modulate = Color(0, 1, 0)
		get_tree().change_scene_to_file("res://scenes/Menu/Connection.tscn")
	else:
		notif.text = "❌ Invalid code or incorrect email."
		notif.modulate = Color(1, 0, 0)
	
func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Menu/Connection.tscn")
