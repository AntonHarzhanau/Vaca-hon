extends Control

# Button node references
@onready var creer_partie_button = $control/CREER
@onready var rejoindre_partie_button = $control/REJOINDRE
@onready var return_button = $control/ColorRect/TextureButton

func _ready():
	pass  # 删除信号连接部分

# When "CRÉER UNE PARTIE" is clicked, switch to create_lobby2.tscn
func _on_creer_pressed() -> void:
	print("Attempting to load scene: res://scenes/Menu/create_lobby2.tscn")
	var scene = load("res://scenes/Menu/create_lobby2.tscn")  # 加载目标场景
	if scene:
		print("Scene loaded successfully!")  # 确认场景加载成功
		get_tree().change_scene_to_file("res://scenes/Menu/create_lobby2.tscn")  # 切换场景
	else:
		print("Failed to load scene.")  # 如果加载失败，输出错误信息

# When "REJOINDRE UNE PARTIE" is clicked, switch to list_lobby2.tscn
func _on_rejoindre_pressed() -> void:
	print("Attempting to load scene: res://scenes/Menu/list_lobby2.tscn")
	var scene = load("res://scenes/Menu/list_lobby2.tscn")  # 加载目标场景
	if scene:
		print("Scene loaded successfully!")  # 确认场景加载成功
		get_tree().change_scene_to_file("res://scenes/Menu/list_lobby2.tscn")  # 切换场景
	else:
		print("Failed to load scene.")  # 如果加载失败，输出错误信息

# When the return button is clicked, go back to home.tscn
func _on_texture_button_pressed() -> void:
	print("Attempting to return to home scene: res://scenes/Menu/home.tscn")
	var scene = preload("res://scenes/Menu/home.tscn")
	if scene:
		print("Scene loaded successfully!")
		get_tree().change_scene_to_file("res://scenes/Menu/home.tscn")
	else:
		print("Failed to load scene.")
