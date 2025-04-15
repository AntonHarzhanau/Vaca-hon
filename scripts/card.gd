extends Control

@onready var back: ColorRect= $BackGround
@onready var label: Label = $BackGround/Label
var image = preload("res://assets/airport.png")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#label.text = "djfsifjsd"
	#back.position.x += 100
	#back.rotation += 90
	$BackGround/Sprite2D.texture = image

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
