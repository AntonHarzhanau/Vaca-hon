extends Control

@onready var settings_panel = $SettingsPanel

#func _ready():
	#settings_panel.visible = false


func _on_close_button_pressed() -> void:
	$".".visible = false

	pass # Replace with function body.


func _on_parametre_pressed() -> void:
	settings_panel.visible = true

	pass # Replace with function body.
