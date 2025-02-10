@tool
extends PropertyCell
class_name RailWayCell

@onready var image: TextureRect = $Image
@export var texture: Texture2D

func _ready():
	super._ready()
	if image:
		image.texture = texture
		image.scale = Vector2(0.5, 0.5)
