@tool
extends Node2D
class_name Cell

@onready var back_ground:ColorRect = $BackGround
@onready var label_name: Label = $BackGround/Name

@export var cell_name: String
var id_space: int

func _ready():
	# centering child elements
	label_name.pivot_offset = label_name.size / 2
	back_ground.pivot_offset = back_ground.size / 2
	if label_name:
		label_name.text = str(cell_name)

# update centers after resizing
func update():
	back_ground.position = $".".position - back_ground.size / 2
	back_ground.pivot_offset = back_ground.size / 2
	
# cell event activation
func activate(_player: Player):
	#print(cell_name)
	pass
func show_cell():
	pass
