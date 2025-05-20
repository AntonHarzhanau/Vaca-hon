extends Node2D
class_name Player
signal state_changed()

var id: int
var player_name: String
var money: int  = 0
var current_position: int = 0
var nb_turn_jail: int = 0
var nb_railway: int = 0
var nb_utility: int = 0
var timer_turn: int = 0
var properties:Array[PropertyCell] = []
var player_color: Color
var bonus: int = 0

var speed = 300
var moving = false
var target_position


@onready var player_token_sprite: Sprite2D = $Sprite2D
@export var player_token = preload("res://icon.svg")

func _ready() -> void:
	player_token_sprite.texture = player_token

func _process(delta):
	if moving:
		position = position.move_toward(target_position, speed * delta)

		if position.distance_to(target_position) < 1.0:
			moving = false

# player movement across the field cell by cell
func move(cells_list: Array[Cell], steps: int, current_pos:int):
	var temp_pos = current_position
	current_position = current_pos % cells_list.size()
	var direction = sign(steps)
	var abs_steps = abs(steps)

	for i in abs_steps:
		temp_pos = (temp_pos + direction + cells_list.size()) % cells_list.size()
		$".".global_position = cells_list[temp_pos].global_position
		await get_tree().create_timer(0.3).timeout
	
	cells_list[current_position].activate(self)
	if self.id == UserData.user_id:
		var message = {
			"action": "cell_activate",
			"cell_id": cells_list[current_position].id_space,
			"player_id": id
		}
		WebSocketClient.send_message(JSON.stringify(message))

func buy_property(cell: PropertyCell, price:int, current_rent:int) -> void:
	cell.buy_property(self, current_rent)
	emit_signal("state_changed", self)

func sell_property(property_id: int, price: int, current_rent:int):
	for i in properties:
		if i.id_space == property_id:
			i.sell_property(self, current_rent)
			emit_signal("state_changed", self)

func get_property(cell_id:int):
	for prop in properties:
		if prop.id_space == cell_id:
			return prop

func pay(price:int):
	AudioManager.play_sfx(States.LOSE_SOUND)
	money -= price
	emit_signal("state_changed", self)

func earn(price:int):
	AudioManager.play_sfx(States.GAIN_SOUND)
	money += price
	emit_signal("state_changed", self)

func go_to_jail(cells: Array[Cell]):
	self.current_position = 10
	self.nb_turn_jail = 2
	self.move_to(cells[10].position)
	
func move_to(pos: Vector2):
	target_position = pos
	moving = true

func move_through_center(center_position: Vector2, final_cell_position: Vector2) -> void:
	# Этап 1: движение в центр
	target_position = center_position
	moving = true
	await _wait_until_reached()

	# Этап 2: движение в целевую ячейку
	target_position = final_cell_position
	moving = true
	await _wait_until_reached()

func _wait_until_reached() -> void:
	while moving:
		await get_tree().process_frame

func set_bonus(bonus:int):
	self.bonus = bonus
	emit_signal("state_changed", self)

func set_turn_timer():
	pass
