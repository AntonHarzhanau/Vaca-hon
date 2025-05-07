extends Control

@onready var regle_button = $HBoxContainer/MarginContainer/VBoxContainer2/Regle
@onready var regle_popup = $Regle_du_jeu
@onready var log_out_popup = $Log_out
@onready var log_out_button = $HBoxContainer/MarginContainer3/Connection
@onready var overlay := $Overlay

@onready var support_button = $HBoxContainer/MarginContainer/VBoxContainer2/Support
@onready var parametre_button = $HBoxContainer/MarginContainer/VBoxContainer2/Parametre
@onready var jouer_button = $HBoxContainer/MarginContainer2/VBoxContainer/Jouer
@onready var trouver_button = $HBoxContainer/MarginContainer2/VBoxContainer/Trouver

var popup_target_pos := Vector2(256, 201)
var popup_start_pos := Vector2(256, 800)

func _ready():
	regle_button.connect("pressed", Callable(self, "_on_regle_pressed"))
	regle_popup.visible = false
	log_out_button.connect("pressed", Callable(self, "_on_connection_pressed"))
	log_out_popup.visible = false
	overlay.visible = false
	overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE  # 允许点击穿透

	#support_button.connect("pressed", Callable(self, "_on_support_pressed"))
	#parametre_button.connect("pressed", Callable(self, "_on_parametre_pressed"))
	#jouer_button.connect("pressed", Callable(self, "_on_jouer_pressed"))
	#trouver_button.connect("pressed", Callable(self, "_on_trouver_pressed"))
	
	# Setup player name if already logged in
	if UserData.user_name:
		log_out_button.text = log_out_button.text.replace("PLAYER NAME", UserData.user_name)

func _on_regle_pressed():
	regle_popup.visible = !regle_popup.visible

func _on_support_pressed():
	var path = "res://scenes/Menu/Support.tscn"
	if ResourceLoader.exists(path):
		get_tree().change_scene_to_file(path)

func _on_parametre_pressed():
	var path = "res://scenes/Menu/Parametre.tscn"
	if ResourceLoader.exists(path):
		get_tree().change_scene_to_file(path)

func _on_jouer_pressed():
	var path = "res://scenes/Menu/main_menu2.tscn"
	if ResourceLoader.exists(path):
		get_tree().change_scene_to_file(path)

func _on_trouver_pressed():
	print("Trouver pressed")
	var path = "res://scenes/Menu/list_lobby2.tscn"
	if ResourceLoader.exists(path):
		print("path found : ", path)
		get_tree().change_scene_to_file(path)

func _on_connection_pressed() -> void:
	overlay.visible = true
	log_out_popup.visible = true
	log_out_popup.position = popup_start_pos

	var tween = create_tween()
	tween.tween_property(log_out_popup, "position", popup_target_pos, 0.4)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _on_non_pressed() -> void:
	var tween = create_tween()
	tween.tween_property(log_out_popup, "position", popup_start_pos, 0.3)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	await tween.finished
	log_out_popup.visible = false
	overlay.visible = false

func _on_oui_pressed() -> void:
	var path = "res://scenes/Menu/Connection.tscn"
	if ResourceLoader.exists(path):
		get_tree().change_scene_to_file(path)

func _on_close_area_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		regle_popup.visible = false
