extends CanvasLayer

@onready var settings_panel = $Panel/SettingsPanel

#func _ready():
	#settings_panel.visible = false


func _on_close_button_pressed() -> void:
	$".".visible = false

	pass # Replace with function body.


func _on_parametre_pressed() -> void:
	settings_panel.visible = true

	pass # Replace with function body.

func _on_h_slider_1_value_changed(value: float) -> void:
	var min_db = -70.0
	var max_db = 6.0
	var volume_db = lerp(min_db, max_db, value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), volume_db - 24.0)


func _on_h_slider_2_value_changed(value: float) -> void:
	var min_db = -70.0
	var max_db = 6.0
	var volume_db = lerp(min_db, max_db, value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), volume_db - 24.0)
