@tool
extends PropertyCell
class_name UtilityCell

@onready var image = $BackGround/Image

@export var texture: Texture2D

func _ready():
	super._ready()
	image.pivot_offset = image.size /2
	if image:
		image.texture = texture
