extends Control

signal accept_offer_clicked
signal reject_offer_clicked

@onready var label_offer = $Back_ground/Label
@onready var accept_btn = $Back_ground/Button_container/Accept_btn
@onready var deny_btn = $Back_ground/Button_container/Deny_btn

func _ready():
	accept_btn.pressed.connect(_on_accept_pressed)
	deny_btn.pressed.connect(_on_deny_pressed)

func show_offer(cell_name: String, price: int):
	label_offer.text = "Do you want to buy " + cell_name + " for $" + str(price) + "?"
	visible = true
	#TODO: add check if the player has enough money and hide accept_btn if there is not enough money

func _on_accept_pressed():
	var msg = {"action": "accepted_offer"}
	WebSocketClient.send_message(JSON.stringify(msg))
	visible = false

func _on_deny_pressed():
	visible = false
