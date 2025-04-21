extends Control

# 按钮节点引用
@onready var creer_partie_button = $control/CREER
@onready var rejoindre_partie_button = $control/REJOINDRE

func _ready():
	# 信号已经在编辑器中连接，因此这里不需要手动连接
	pass  # 删除信号连接部分

# 当点击 "CRÉER UNE PARTIE" 按钮时，切换到 create_lobby2.tscn
func _on_creer_pressed() -> void:
	print("Attempting to load scene: res://scenes/Menu/create_lobby2.tscn")
	var scene = load("res://scenes/Menu/create_lobby2.tscn")  # 加载目标场景
	if scene:
		print("Scene loaded successfully!")  # 确认场景加载成功
		get_tree().change_scene_to_file("res://scenes/Menu/create_lobby2.tscn")  # 切换场景
	else:
		print("Failed to load scene.")  # 如果加载失败，输出错误信息

# 当点击 "REJOINDRE UNE PARTIE" 按钮时，切换到 list_lobby2.tscn
func _on_rejoindre_pressed() -> void:
	print("Attempting to load scene: res://scenes/Menu/list_lobby2.tscn")
	var scene = load("res://scenes/Menu/list_lobby2.tscn")  # 加载目标场景
	if scene:
		print("Scene loaded successfully!")  # 确认场景加载成功
		get_tree().change_scene_to_file("res://scenes/Menu/list_lobby2.tscn")  # 切换场景
	else:
		print("Failed to load scene.")  # 如果加载失败，输出错误信息
