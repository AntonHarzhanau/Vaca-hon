@tool
extends PropertyCell
class_name RailWayCell

@onready var texture: TextureRect = $BackGround/TextureRect
var image: Texture2D

func _ready():
	super._ready()
	$BackGround/TextureRect.pivot_offset = $BackGround/TextureRect.size / 2
	texture.texture = image
