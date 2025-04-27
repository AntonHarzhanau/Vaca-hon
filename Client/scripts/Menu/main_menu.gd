extends Control

@onready var exit_btn: Button = $ColorRect/VBoxContainer/Exit
@onready var http_url: TextEdit = $ColorRect/VBoxContainer/HBoxContainer/HTTP_URL
@onready var ws_url: TextEdit = $ColorRect/VBoxContainer/HBoxContainer/WS_URL
@onready var save:Button = $ColorRect/VBoxContainer/HBoxContainer/Save
@onready var registation = $CanvasLayer/Registration
@onready var auth = $CanvasLayer/Authentication

@onready var ip:Label = $ColorRect/IP
@onready var ip2:Label = $ColorRect/IP2

func _ready() -> void:
	ip.text = "CURRENT HTTP URL : " + States.HTTP_BASE_URL
	ip2.text = "CURRENT WS URL : " + States.WS_BASE_URL
	
func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_create_lobby_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Menu/create_lobby.tscn")

func _on_join_lobby_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Menu/list_lobby.tscn")

func _on_save_pressed() -> void:
	States.HTTP_BASE_URL = http_url.text
	States.WS_BASE_URL = ws_url.text
	ip.text = "CURRENT HTTP URL : " + States.HTTP_BASE_URL
	ip2.text = "CURRENT WS URL : " + States.WS_BASE_URL
	HttpRequestClient.set_base_url(States.HTTP_BASE_URL)

func _on_login_pressed() -> void:
	$CanvasLayer.visible = true

func _on_registration_shange_on_login() -> void:
	registation.visible = false
	auth.visible = true

func _on_authentication_change_to_login() -> void:
		registation.visible = true
		auth.visible = false

func _on_close_auth_pressed() -> void:
	$CanvasLayer.visible = false

func _on_test_toggled(toggled_on: bool) -> void:
	States.is_test = toggled_on
