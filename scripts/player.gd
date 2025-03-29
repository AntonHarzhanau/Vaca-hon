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
	
# player movement across the field cell by cell
func move(cells_list:Array[Cell], next_position: int):
	var temp_pos = current_position
	var number_of_steps = next_position - current_position if next_position >= current_position else 40 - current_position + next_position
	for i in number_of_steps:
		temp_pos += 1 
		temp_pos %= cells_list.size()
		$".".global_position = cells_list[temp_pos].global_position
		await get_tree().create_timer(0.5).timeout 
	current_position = next_position
	var message = {"action": "cell_activate", "cell_id": cells_list[current_position].id_space, "player_id": id}
	WebSocketClient.send_message(JSON.stringify(message))

func buy_property(cell: PropertyCell, price:int, current_rent:int) -> void:
	cell.buy_property(self, current_rent)
	emit_signal("state_changed", self)
	cell.prop_lable.color = player_color
	cell.prop_lable.visible = true

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
	money -= price
	emit_signal("state_changed", self)

func earn(price:int):
	money += price
	emit_signal("state_changed", self)

func set_turn_timer():
	pass
