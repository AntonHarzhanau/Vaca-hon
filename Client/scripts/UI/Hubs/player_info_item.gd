extends NinePatchRect

func _ready():
	if not $Details.pressed.is_connected(_on_details_pressed):
		$Details.pressed.connect(_on_details_pressed)

func _on_details_pressed():
	# 自动向上查找 PlayerInfo 节点
	var player_info = find_parent_player_info()
	if player_info and player_info.has_method("show_property_card"):
		player_info.show_property_card()

func find_parent_player_info():
	var current = self.get_parent()
	while current:
		if current.name == "PlayerInfo":  # 名字严格匹配
			return current
		current = current.get_parent()
	return null
