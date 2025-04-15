@tool
extends PropertyCell
class_name UtilityCell

@onready var texture: TextureRect = $BackGround/TextureRect
@export var image: Texture2D

func _ready():
	super._ready()
	texture.pivot_offset = texture.size / 2
	if image:
		texture.texture = image
