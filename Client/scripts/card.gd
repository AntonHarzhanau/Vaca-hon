extends Control

@onready var label: Label = $Avatar/Panel3/MarginContainer/Label


# Called when the node enters the scene tree for the first time.
var player_name: String = ""
var texture: Texture2D
var player_color: Color

func _ready() -> void:
	label.text = player_name.to_upper() + "’S TURN"
	$Avatar.avatar.texture = texture
	var style = $Avatar/Panel3.get_theme_stylebox("panel").duplicate()
	style.bg_color = player_color
	$Avatar/Panel3.add_theme_stylebox_override("panel", style)
	
	var avatar_style = $Avatar.style_panel.get_theme_stylebox("panel").duplicate()
	avatar_style.bg_color = player_color
	$Avatar.style_panel.add_theme_stylebox_override("panel", avatar_style)
	var avatar_style2 = $Avatar.style_panel2.get_theme_stylebox("panel").duplicate()
	avatar_style2.border_color = player_color
	$Avatar.style_panel2.add_theme_stylebox_override("panel", avatar_style2)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_timer_timeout() -> void:
	self.queue_free()
