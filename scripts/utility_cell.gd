@tool
extends PropertyCell
class_name UtilityCell

@onready var image: TextureRect = $Image

@export var texture: Texture2D

func _ready():
	super._ready()
	if image:
		image.texture = texture  # Применяем изображение
