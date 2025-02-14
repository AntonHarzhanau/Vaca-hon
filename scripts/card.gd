extends Control

@onready var back = $BackGround
@onready var label = $BackGround/Label
var image = preload("res://assets/train.png")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#label.text = "djfsifjsd"
	#back.position.x += 100
	#back.rotation += 90
	$BackGround/Sprite2D.texture = image

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
