@tool
extends Cell
class_name EventCell

@onready var texture: TextureRect = $BackGround/Image
@export var image: Texture2D

func _ready():
	super._ready()
	texture.pivot_offset = texture.size / 2
	if image:
		texture.texture = image
