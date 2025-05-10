extends Panel
class_name FlyOffer

@onready var offer: Label = $VBoxContainer/Offer
var cell_id:int

func show_offer(message:String, cell_id:int):
	self.cell_id = cell_id
	self.visible = true

func _on_accept_btn_pressed() -> void:
	var msg = {"action": "accept_fly", "player_id": UserData.user_id, "cell_id": self.cell_id}
	WebSocketClient.send_message(JSON.stringify(msg))
	self.visible = false

func _on_deny_btn_pressed() -> void:
	self.visible = false
