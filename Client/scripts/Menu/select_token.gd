extends Control

@onready var quitter_partie = $TextureRect/quitter_partie
@onready var return_button = $TextureRect/ColorRect/TextureButton
@onready var texture_rect := $TextureRect
@onready var overlay := $TextureRect/Overlay

# 小图标按钮节点
@onready var button_flight = $TextureRect/ScrollContainer/CenterContainer/HBoxContainer/flight
@onready var button_ship = $TextureRect/ScrollContainer/CenterContainer/HBoxContainer/ship
@onready var button_car = $TextureRect/ScrollContainer/CenterContainer/HBoxContainer/car
@onready var button_helicopter = $TextureRect/ScrollContainer/CenterContainer/HBoxContainer/helicopter
@onready var button_support = $TextureRect/Support

# 大图节点
@onready var img_flight = $TextureRect/flight
@onready var img_ship = $TextureRect/ship
@onready var img_car = $TextureRect/car
@onready var img_helicopter = $TextureRect/helicopter

# 当前选中的按钮
var selected_button: BaseButton = null

var popup_target_pos := Vector2(256, 201)
var popup_start_pos := Vector2(256, 800)

func _ready():
	quitter_partie.visible = false
	overlay.visible = false
	overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE  

	# 默认显示飞机
	_show_selected_token("flight")
	_set_selected_button(button_flight)

	# 连接所有按钮
	button_flight.connect("pressed", _on_flight_pressed)
	button_ship.connect("pressed", _on_ship_pressed)
	button_car.connect("pressed", _on_car_pressed)
	button_helicopter.connect("pressed", _on_helicopter_pressed)
	#button_support.connect("pressed", _on_support_pressed)


func _on_texture_button_pressed() -> void:
	quitter_partie.visible = true
	overlay.visible = true
	quitter_partie.position = popup_start_pos  # 保证初始在屏幕下方

	var tween = create_tween()
	tween.tween_property(quitter_partie, "position", popup_target_pos, 0.4)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _on_non_pressed() -> void:
	var tween = create_tween()
	tween.tween_property(quitter_partie, "position", popup_start_pos, 0.3)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	await tween.finished
	quitter_partie.visible = false
	overlay.visible = false

func _on_oui_pressed() -> void:
	var path = "res://scenes/Menu/home.tscn"
	if ResourceLoader.exists(path):
		get_tree().change_scene_to_file(path)

func _on_support_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Menu/lobby_wait.tscn")


# 四个 Token 按钮点击时
func _on_flight_pressed():
	_show_selected_token("flight")
	_set_selected_button(button_flight)

func _on_ship_pressed():
	_show_selected_token("ship")
	_set_selected_button(button_ship)

func _on_car_pressed():
	_show_selected_token("car")
	_set_selected_button(button_car)

func _on_helicopter_pressed():
	_show_selected_token("helicopter")
	_set_selected_button(button_helicopter)

# 切换大图显示
func _show_selected_token(selected: String) -> void:
	img_flight.visible = (selected == "flight")
	img_ship.visible = (selected == "ship")
	img_car.visible = (selected == "car")
	img_helicopter.visible = (selected == "helicopter")

# 切换选中按钮样式
func _set_selected_button(button: BaseButton) -> void:
	# 把之前选中的按钮恢复成 normal
	if selected_button and selected_button != button:
		selected_button.button_pressed = false

	# 当前按钮设置为 pressed
	selected_button = button
	selected_button.button_pressed = true
