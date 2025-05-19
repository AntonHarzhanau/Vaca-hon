extends CanvasLayer

signal accept_offer_clicked
signal reject_offer_clicked

@onready var label_offer:Label = $Panel/Back_ground/Label
@onready var title_label:Label = $Panel/Back_ground/Title
@onready var accept_btn:Button = $Panel/Back_ground/Button_container/Accept_btn
@onready var deny_btn:Button = $Panel/Back_ground/Button_container/Deny_btn

func _ready():
	accept_btn.pressed.connect(_on_accept_pressed)
	deny_btn.pressed.connect(_on_deny_pressed)

func show_offer():
	title_label.text = "JAIL"
	label_offer.text = "Do you want to pay 50 to get out of jail?"
	if States.players[UserData.user_id].bonus > 0:
		$Panel/Back_ground/UseCard.visible = true
	else:
		$Panel/Back_ground/UseCard.visible = false
	if States.players[UserData.user_id].money >= 50:
		$Panel/Back_ground/Button_container/Accept_btn.disabled = false
	else:
		$Panel/Back_ground/Button_container/Accept_btn.disabled = true
	visible = true

func _on_accept_pressed():
	var msg = {"action": "jail_decision", "accepted": true}
	WebSocketClient.send_message(JSON.stringify(msg))
	visible = false

func _on_deny_pressed():
	var msg = {"action": "jail_decision", "accepted": false}
	WebSocketClient.send_message(JSON.stringify(msg))
	visible = false

func _on_use_card_pressed() -> void:
	var msg = {"action": "use_card", "player_id": UserData.user_id}
	WebSocketClient.send_message(JSON.stringify(msg))
	visible = false
