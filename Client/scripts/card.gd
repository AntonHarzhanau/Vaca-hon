extends Control

@onready var back: ColorRect= $BackGround
@onready var label: Label = $BackGround/Label
@onready var image: TextureRect = $BackGround/Image
# Called when the node enters the scene tree for the first time.
var texture: Texture2D
func _ready() -> void:
	#label.text = "djfsifjsd"
	#back.position.x += 100
	#back.rotation += 90
	self.image.texture = texture

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
