extends Control

# 添加四个方向的常量（用于设置圆角）
const SIDE_TOP_LEFT = 0
const SIDE_TOP_RIGHT = 1
const SIDE_BOTTOM_RIGHT = 2
const SIDE_BOTTOM_LEFT = 3

@onready var filter_button = $TextureRect/MenuButton
@onready var filter_menu = $TextureRect/VBoxContainer
@onready var button_publique = filter_menu.get_node("Parties publiques")
@onready var button_privee = filter_menu.get_node("Parties privees")

# 存储按钮的状态
var is_expanded := false
var selected_button: Button = null
var default_style: StyleBoxFlat = null

# 按钮节点引用，用于返回场景
@onready var texture_button = $TextureRect/TextureButton

func _ready():
	# 保存默认样式（从 publiques 获取）
	var base_style = button_publique.get("theme_override_styles/normal")
	if base_style:
		default_style = base_style.duplicate()
	
	# 初始化状态
	filter_menu.visible = false
	filter_button.text = "  FILTRER         ▼"

	# 信号连接
	filter_button.connect("pressed", _on_filter_button_pressed)
	button_publique.connect("pressed", _on_publique_pressed)
	button_privee.connect("pressed", _on_privee_pressed)

   
func _on_filter_button_pressed():
	is_expanded = !is_expanded
	filter_menu.visible = is_expanded
	filter_button.text = "  FILTRER         ▲" if is_expanded else "  FILTRER         ▼"

func _on_publique_pressed():
	_select_button(button_publique)
	print("筛选：Parties publiques")

func _on_privee_pressed():
	_select_button(button_privee)
	print("筛选：Parties privées")

func _select_button(button: Button):
	# 重置上一个按钮样式
	if selected_button and selected_button != button:
		if default_style:
			selected_button.set("theme_override_styles/normal", default_style.duplicate())

	# 使用 hover 样式作为 normal
	var hover_style = button.get("theme_override_styles/hover")
	if hover_style:
		button.set("theme_override_styles/normal", hover_style.duplicate())

	selected_button = button

# 当点击返回按钮时，切换回主菜单场景
func _on_texture_button_pressed() -> void:
	print("Attempting to load scene: res://scenes/Menu/main_menu2.tscn")
	var scene = load("res://scenes/Menu/main_menu2.tscn")
	if scene:
		print("Scene loaded successfully!")
		get_tree().change_scene_to_file("res://scenes/Menu/main_menu2.tscn")  # 切换到主菜单场景
	else:
		print("Failed to load scene.")
