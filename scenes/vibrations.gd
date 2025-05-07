extends CheckBox

var tween: Tween = null

func _ready():
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.2)\
		.set_trans(Tween.TRANS_ELASTIC)\
		.set_ease(Tween.EASE_OUT)

func _on_mouse_exited() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1, 1), 0.2)\
		.set_trans(Tween.TRANS_ELASTIC)\
		.set_ease(Tween.EASE_IN)
