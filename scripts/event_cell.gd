@tool
extends Cell
class_name EventCell

@onready var image = $Image
@export var texture: Texture2D

func _ready():
	super._ready()
	if image:
		image.texture = texture
