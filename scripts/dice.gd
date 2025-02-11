extends Area2D

# Объявляем сигнал, который передаст результат броска (число от 1 до 6)
signal dice_rolled(result: int)

@onready var dice_sprite: AnimatedSprite2D = $DiceSprite
@onready var timer: Timer = $RollTimer

func _ready() -> void:
	# Настраиваем таймер: время броска и однократный запуск
	timer.timeout.connect(_on_timer_timeout)

# Событие вызывается, когда пользователь кликает по области, заданной CollisionShape2D
func _input_event(viewport, event, shape_idx) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		roll_dice()

# Функция запускает анимацию броска кубика
func roll_dice() -> void:
	dice_sprite.play("roll")
	timer.start()

# Функция, вызываемая по сигналу таймера (по окончании анимации)
func _on_timer_timeout() -> void:
	dice_sprite.stop()
	# Получаем количество кадров в анимации "roll"
	var frame_count = dice_sprite.sprite_frames.get_frame_count("roll")
	# Выбираем случайный кадр от 0 до frame_count - 1
	var final_frame = randi() % frame_count
	dice_sprite.frame = final_frame

	# Преобразуем номер кадра в число кубика (например, если кадры 0-5, то результат 1-6)
	var dice_result = final_frame + 1

	# Отправляем сигнал с результатом броска
	emit_signal("dice_rolled", dice_result)
	print("Выпало число: ", dice_result)
	
