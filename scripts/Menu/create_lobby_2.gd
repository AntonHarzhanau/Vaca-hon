extends Control

# 保存按钮组
@onready var group_joueurs = $TextureRect/MarginContainer/Panel/HBoxContainer.get_children()
@onready var group_temps = $TextureRect/MarginContainer/Panel/HBoxContainer2.get_children()
@onready var group_type = $TextureRect/MarginContainer/Panel/HBoxContainer3.get_children()

# 密码相关
@onready var label_mdp = $TextureRect/MarginContainer/Panel/Label5
@onready var lineedit_mdp = $TextureRect/MarginContainer/Panel/LineEdit

# 存储每个按钮的初始 normal 样式
var default_styles := {}

# 按钮节点引用
@onready var texture_button = $TextureRect/TextureButton

func _ready():
	# 连接所有按钮组
	_connect_buttons(group_joueurs)
	_connect_buttons(group_temps)
	_connect_buttons(group_type)

	# 初始隐藏密码字段
	label_mdp.visible = false
	lineedit_mdp.visible = false

	
func _connect_buttons(button_group: Array):
	for button in button_group:
		if button is Button:
			# 保存按钮初始 normal 样式
			var base_style = button.get("theme_override_styles/normal")
			if base_style:
				default_styles[button] = base_style.duplicate()
			button.connect("pressed", _on_group_button_pressed.bind(button_group, button))

func _on_group_button_pressed(button_group: Array, selected: Button):
	for button in button_group:
		if button != selected:
			# 恢复默认 normal 样式
			if default_styles.has(button):
				button.set("theme_override_styles/normal", default_styles[button].duplicate())

	# 设置选中按钮样式（使用 hover 样式复制）
	var hover_style = selected.get("theme_override_styles/hover")
	if hover_style:
		selected.set("theme_override_styles/normal", hover_style.duplicate())

	# 特殊情况：显示/隐藏 mot de passe
	if selected.name == "Button_Privee":
		label_mdp.visible = true
		lineedit_mdp.visible = true
	elif selected.name == "Button_Publique":
		label_mdp.visible = false
		lineedit_mdp.visible = false

# 当点击返回按钮时，切换回主菜单场景
func _on_texture_button_pressed() -> void:
	print("Attempting to load scene: res://scenes/Menu/main_menu2.tscn")
	var scene = load("res://scenes/Menu/main_menu2.tscn")
	if scene:
		print("Scene loaded successfully!")
		get_tree().change_scene_to_file("res://scenes/Menu/main_menu2.tscn")  # 切换到主菜单场景
	else:
		print("Failed to load scene.")
