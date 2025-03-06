extends Node2D

var id: int
var money: int  = 0
var current_position: int = 0
var nb_turn_jail: int = 0
var nb_railway: int = 0
var nb_utility: int = 0
var timer_turn: int = 0
var properties:Array[Cell] = []

# player movement across the field cell by cell
func move(cells_list, number_of_steps):
	var temp_pos = current_position
	for i in number_of_steps:
		temp_pos += 1 
		temp_pos %= cells_list.size()
		$".".global_position = cells_list[temp_pos].global_position
		await get_tree().create_timer(0.5).timeout 
	current_position = temp_pos
	var message = {"action": "cell_activate", "cell_id": cells_list[current_position].id_space, "player_id": id}
	WebSocketClient.send_message(JSON.stringify(message))
	
func sell_property(property_id: int, price: int):
	for i in properties:
		if i.id_space == property_id:
			i.cell_owner = null
			money += price
			properties.erase(i)
func set_turn_timer():
	pass
