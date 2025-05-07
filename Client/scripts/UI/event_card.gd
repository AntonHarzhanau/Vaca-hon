extends CanvasLayer

class_name EventCard

@onready var descripton: Label = $Background/Description
@onready var back: TextureRect  = $Background

var image_back_chance
var image_back_community 

func _ready() -> void:
	image_back_chance = load("res://assets/Event Cells/Chance Card.png")
	image_back_community = load("res://assets/Event Cells/Community Chest Card.png")

func _on_close_btn_pressed() -> void:
	self.visible = false

func show_card(type:String):
	if type == "chance":
		back.texture = image_back_chance
	elif  type == "community":
		back.texture = image_back_community
	#self.description = description

func _on_Background_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		hide()  # or queue_free() if the popup won't be reused
