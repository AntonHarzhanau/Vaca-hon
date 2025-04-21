extends TextureButton

@export var token_name = "Unknown"
@export var token_texture = preload("res://assets/Players/FLIGHT.png")

func _ready() -> void:
	# Set texture
	self.texture_normal = token_texture
	
