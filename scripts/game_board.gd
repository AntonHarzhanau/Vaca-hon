@tool
extends Control

const JSON_FILE_PATH: String = "res://data.json"

# Cell scenes
const CELL_SCENE = preload("res://scenes/cell.tscn")
const PROPERTY_SCENE = preload("res://scenes/property_cell.tscn")
const STREET_SCENE = preload("res://scenes/street_cell.tscn")
const RAILWAY_SCENE = preload("res://scenes/rail_way_cell.tscn")
const UTILITY_SCENE = preload("res://scenes/utility_cell.tscn")
const EVENT_SCENE = preload("res://scenes/event_cell.tscn")
const CORNER_SCENE = preload("res://scenes/corner_cell.tscn")

const CELL_COUNT = 9  # Number of cells on each side

@onready var game_board = $Centre

var board_rect  # Bounding rectangle of game_board
var top_left
var bottom_right
var top_right
var bottom_left

@export var cell_height = 120
# Button for creating/updating cards in the editor
@export var create_cells_in_editor: bool = false : set = _on_create_cells_in_editor

# Button for deleting cards in the editor
@export var remove_cells_in_editor: bool = false : set = _on_remove_cells_in_editor


func _ready():
	board_rect = game_board.get_rect()
	top_left = board_rect.position
	bottom_right = board_rect.end
	top_right = Vector2(bottom_right[0],top_left[0])
	bottom_left = Vector2(top_left[0],bottom_right[0])
	
	# If the game is running (and we are not in the editor)
	if not Engine.is_editor_hint():
		# 1. Check if there are already cards in game_board, created in the editor
		var existing_cards = game_board.get_children()
		if existing_cards.size() > 0:
			# If the cells already exist, just position them
			print("Using cells created in the editor.")
			place_cells()
		else:
			# If there are no cells, load data and create them
			var json_data = load_json(JSON_FILE_PATH)
			if json_data:
				create_cells(json_data)  # Create new cards
				place_cells()
	else:
		# In the editor, do nothing automatically,
		# use buttons/@export logic if available
		place_cells()

# --- BUTTONS IN THE INSPECTOR ---
func _on_create_cells_in_editor(value):
	# If we are in the editor and the user has checked the box
	if Engine.is_editor_hint() and value:
		print("Creating (or recreating) cards in the editor...")
		
		# Preparation
		board_rect = game_board.get_rect()
		top_left = board_rect.position
		bottom_right = board_rect.end
		
		var json_data = load_json(JSON_FILE_PATH)
		
		# Remove old ones, add new ones
		clear_game_board()
		if json_data:
			create_cells(json_data)
			place_cells()
		
		# Reset the flag so the button can be pressed again
		create_cells_in_editor = false


func _on_remove_cells_in_editor(value):
	# If we are in the editor and the user has checked the box
	if Engine.is_editor_hint() and value:
		print("Removing all cards in the editor...")
		clear_game_board()
		
		remove_cells_in_editor = false

func load_json(file_path: String) -> Array:
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file:
		var json_text = file.get_as_text()
		file.close()
		var json = JSON.new()
		var parse_result = json.parse(json_text)
		
		if parse_result == OK:
			return json.data
		else:
			print("ERROR: Parsing JSON")
	else:
		print("ERROR: Open File")
	
	return []

func clear_game_board():
	for child in game_board.get_children():
		child.queue_free()
	# To ensure nodes are deleted within a single frame in the editor,
	# we can wait for a frame, but it's not always necessary.
	# await get_tree().process_frame

# creating cells from .json file
func create_cells(json_data: Array):
	for item in json_data:
		var cell_instance # variable for instance
		match item["type"]:
			"Street":
				cell_instance = STREET_SCENE.instantiate()
				cell_instance.name = item["name"] # used to set a name in the editor (only works with unique names)
				cell_instance.cell_name = item["name"]
				cell_instance.price = item["cost"]
				cell_instance.group_color = get_color(item["color"])
			
			"RailWay":
				cell_instance = RAILWAY_SCENE.instantiate()
				cell_instance.name = item["name"]
				cell_instance.cell_name = item["name"]
				cell_instance.price = item["cost"]
			
			"Utility":
				cell_instance = UTILITY_SCENE.instantiate()
				cell_instance.name = item["name"]
				cell_instance.cell_name = item["name"]
				cell_instance.price = item["cost"]
			
			"Event":
				cell_instance = EVENT_SCENE.instantiate()
				cell_instance.name = item["name"]
				cell_instance.cell_name = item["name"]
			
			"Сorner":
				cell_instance = CORNER_SCENE.instantiate()
				cell_instance.name = item["name"]
				cell_instance.cell_name = item["name"]
		
		game_board.add_child(cell_instance) # add instance to gameboard
		
		# If nodes need to be visible in the editor
		if Engine.is_editor_hint():
			cell_instance.set_owner(get_tree().edited_scene_root)

# Places cells around the playing field
func place_cells():
	var cards = game_board.get_children()
	if cards.is_empty():
		print("No cards to place!")
		return

	var cell_width_horizontal = board_rect.size.x / CELL_COUNT
	var cell_width_vertical = board_rect.size.y / CELL_COUNT
	var corner_cell_offset = Vector2(cell_height / 2, cell_height / 2)
	
	# Corner positions
	var corners = [
		bottom_right + corner_cell_offset, # down right
		bottom_left + corner_cell_offset * Vector2(-1, 1), # down left
		top_left + corner_cell_offset * Vector2(-1, -1), # up left
		top_right + corner_cell_offset * Vector2(1, -1) # up right
	]
	
	# Place corners
	var corner_counter = 0
	for card in cards:
		if card is CornerCell:
			card.position = corners[corner_counter]
			corner_counter += 1
	
	var start_position = Vector2.ZERO
	var cell_offset = Vector2.ZERO
	var index = 0
	
	# down
	start_position =  Vector2(bottom_right.x + cell_width_horizontal / 2 - cell_width_horizontal, bottom_right.y +  cell_height / 2)
	cell_offset = Vector2(-cell_width_horizontal , 0)
	index = place_side_cell(cards, index, start_position, cell_offset, Vector2(cell_width_horizontal, cell_height), 0)

	# left
	start_position =  Vector2(top_left.x -cell_height / 2, bottom_right.y -cell_width_vertical / 2)
	cell_offset = Vector2(0, -cell_width_vertical)
	index = place_side_cell(cards, index, start_position, cell_offset,Vector2(cell_width_vertical, cell_height), 90)

	# up
	start_position =  Vector2(top_left.x + cell_width_horizontal/2, top_left.y - cell_height / 2)
	cell_offset = Vector2(cell_width_horizontal, 0)
	index = place_side_cell(cards, index, start_position, cell_offset,Vector2(cell_width_horizontal, cell_height), 180)

	# right
	start_position =  Vector2(bottom_right.x + cell_height / 2, top_left.y + cell_width_vertical /2)
	cell_offset = Vector2(0, cell_width_vertical)
	index = place_side_cell(cards, index, start_position, cell_offset,Vector2(cell_width_vertical, cell_height), -90)

# placement of cells on the sides of the playing field
func place_side_cell(cells:Array[Node], start_index: int ,start_position, offset: Vector2, cell_size, rotation_degree: int):
	var index = start_index
	for i in range(CELL_COUNT):
		if cells[index] is CornerCell:
			index += 1
		cells[index].get_node("BackGround").size = cell_size
		cells[index].rotation_degrees = rotation_degree
		cells[index].update_pivot()
		cells[index].position = start_position + offset  * i
		index += 1
	return index

func get_color(color_name: String) -> Color:
	var color_map = {
		"BROWN": Color.BROWN,
		"BLUE": Color.BLUE,
		"RED": Color.RED,
		"GREEN": Color.GREEN,
		"YELLOW": Color.YELLOW,
		"ORANGE": Color.ORANGE,
		"PINK": Color.PINK,
		"PURPLE": Color.PURPLE
	}
	return color_map.get(color_name, Color.WHITE)

func load_texture(file_name: String) -> Texture2D:
	return load("res://assets/train.png")
