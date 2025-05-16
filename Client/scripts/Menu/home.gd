extends Control

@onready var regle_popup = $Regle_du_jeu
@onready var log_out_popup = $Log_out
@onready var log_out_panel = $Log_out/fulltoblock/Panel
@onready var log_out_button = $HBoxContainer/MarginContainer3/Connection

@onready var support_button = $HBoxContainer/MarginContainer/VBoxContainer2/Support
@onready var parametre_button = $HBoxContainer/MarginContainer/VBoxContainer2/Parametre
@onready var jouer_button = $HBoxContainer/MarginContainer2/VBoxContainer/Jouer
@onready var trouver_button = $HBoxContainer/MarginContainer2/VBoxContainer/Trouver

func _ready():
	log_out_popup.visible = false

	# Setup player name if already logged in
	if UserData.user_name:
		log_out_button.text = log_out_button.text.replace("PLAYER NAME", UserData.user_name)
	#for button in get_tree().get_nodes_in_group("HomeButtons"):
		#if button is Button:
			#button.mouse_entered.connect(func(): _hover(button, true))
			#button.mouse_exited.connect(func(): _hover(button, false))
func _on_regle_pressed():
	regle_popup.visible = !regle_popup.visible

func _on_support_pressed():
	var path = "res://scenes/Menu/Support.tscn"
	get_tree().change_scene_to_file(path)

func _on_parametre_pressed():
	var path = "res://scenes/Menu/Parametre.tscn"
	get_tree().change_scene_to_file(path)

func _on_jouer_pressed():
	var path = "res://scenes/Menu/main_menu2.tscn"
	get_tree().change_scene_to_file(path)

func _on_trouver_pressed():
	print("Trouver pressed")
	var path = "res://scenes/Menu/list_lobby2.tscn"
	get_tree().change_scene_to_file(path)

func _on_connection_pressed() -> void:
	log_out_popup.visible = true


func _on_non_pressed() -> void:
	log_out_popup.visible = false

func _on_oui_pressed() -> void:
	var path = "res://scenes/Menu/Connection.tscn"
	get_tree().change_scene_to_file(path)

func _on_close_area_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		regle_popup.visible = false

#func _hover(button: Button, entering: bool):
	#var tween := button.create_tween()
	#var target_scale: Vector2
	#if entering:
		#target_scale = Vector2(1.1, 1.1)
		#tween.set_ease(Tween.EASE_OUT)
	#else:
		#target_scale = Vector2(1, 1)
		#tween.set_ease(Tween.EASE_IN)
#
	#tween.set_trans(Tween.TRANS_ELASTIC)
	#tween.tween_property(button, "scale", target_scale, 0.2)
