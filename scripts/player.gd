extends Node2D

@export var cash = 0
@export var current_position = 0
var property_list: Array[Cell] = []

# player movement across the field cell by cell
func move(cells_list, number_of_steps):
	var temp_pos = current_position
	for i in number_of_steps:
		temp_pos += 1 
		temp_pos %= cells_list.size()
		$".".global_position = cells_list[temp_pos].global_position
		await get_tree().create_timer(0.5).timeout 
	current_position = temp_pos
	cells_list[current_position].activate()
