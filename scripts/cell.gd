@tool
extends Control
class_name Cell

@onready var label_name: Label = $Name

@export var cell_name: String

func _ready():
	if label_name:
		label_name.text = cell_name
	activate()


func activate():
	pass
