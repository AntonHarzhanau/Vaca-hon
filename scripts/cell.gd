@tool
extends Node2D
class_name Cell

@onready var label_name: Label = $BackGround/Name

@export var cell_name: String
var id_space: int

func _ready():
	# centering child elements
	label_name.pivot_offset = label_name.size / 2
	$BackGround.pivot_offset = $BackGround.size / 2
	if label_name:
		label_name.text = cell_name

# update centers after resizing
func update_pivot():
	$BackGround.position = $".".position - $BackGround.size / 2
	$BackGround.pivot_offset = $BackGround.size / 2
	
# cell event activation
func activate(player: Player):
	print(cell_name)
func show_cell():
	pass
