extends CanvasLayer
class_name FlyOffer

@onready var offer: Label = $Panel/Background/Offer
@onready var title_label: Label = $Panel/Background/Title_Label
var cell_id:int

func show_offer(message:String, cell_id:int):
	title_label.text = "Fly Over"
	offer.text = "You own this Airport. \nWould you like to move to \nthe next airport?"
	self.cell_id = cell_id
	self.visible = true

func _on_accept_btn_pressed() -> void:
	var msg = {"action": "accept_fly", "player_id": UserData.user_id, "cell_id": self.cell_id}
	WebSocketClient.send_message(JSON.stringify(msg))
	self.visible = false

func _on_deny_btn_pressed() -> void:
	self.visible = false
