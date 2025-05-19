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

func activate(player:Player):
	AudioManager.play_sfx(preload("res://audio/SFX/sfx_get_card.ogg"))
