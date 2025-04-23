
extends Node2D

@onready var volume_slider = $VBoxContainer/Music
@onready var sfx_slider = $VBoxContainer/SFX
@onready var back_button = $VBoxContainer/Menu
@onready var sfx_click = $SFX_click
func _ready():
	# Charger les réglages sauvegardés
	volume_slider.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))

	#back_button.pressed.connect(_on_back_pressed)

func _on_volume_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value)  # Changer le volume

func _on_fullscreen_toggled(button_pressed):
	if button_pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)  # Activer plein écran
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)  # Désactiver plein écran

func _on_back_pressed():
	get_tree().quit()# Retour au menu


func _on_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/game.tscn")
