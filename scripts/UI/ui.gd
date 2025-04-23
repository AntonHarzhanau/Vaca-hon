extends CanvasLayer 

signal end_turn_clicked
signal move_player_requested(steps)
signal accept_offer_clicked
signal sell_property_clicked(cell_id)

@onready var dice = $Dice
@onready var hub = $Hub
@onready var popup_offer = $PopUpOffre
@onready var end_turn_btn = $EndTurnButton
@onready var turn_lable = $TurnLable
@onready var quit_dialog = $QuitDialog
@onready var help_popup = $HelpPopup
@onready var name_edit = $HelpPopup/VBoxContainer/NameEdit
@onready var phone_edit = $HelpPopup/VBoxContainer/PhoneEdit
@onready var email_edit = $HelpPopup/VBoxContainer/EmailEdit
@onready var message_edit = $HelpPopup/VBoxContainer/MessageEdit
@onready var send_button = $HelpPopup/VBoxContainer/SendButton
@onready var help_button = $HelpButton

var id_player_on_turn: int = 0

func _ready() -> void:
	# Subscribe to signals
	turn_lable.text = "Player's turn: 0"
	dice.dice_rolled.connect(_on_dice_dice_rolled)
	end_turn_btn.pressed.connect(_on_end_turn_button_pressed)
	quit_dialog.confirmed.connect(_on_quit_dialog_confirmed)
	help_popup.hide()
	help_button.pressed.connect(_on_help_button_pressed)
	send_button.pressed.connect(_on_sned_button_pressed)

func _on_dice_dice_rolled(d1: int, d2: int):
	var msg = {"action": "move_player", "steps": d1 + d2}
	WebSocketClient.send_message(JSON.stringify(msg))

# Handling signals from GameManager

func update_hub(money: int, properties: Array):
	hub.set_player_money(money)
	hub.update_properties_list(properties)

func _on_player_disconnected(player_id):
	# Remove from local collection, remove from UI
	pass

func _on_change_turn(player_id:int):
	id_player_on_turn = player_id
	turn_lable.text = "Player's turn: " + str(id_player_on_turn)

func _on_offer_to_buy(cell_id, cell_name, price):
		popup_offer.show_offer(cell_name, price)

func _on_buy_property(money:int, properties:Array[Cell]):
	update_hub(money, properties)
	#TODO: add card to player or cell

func _on_end_turn_button_pressed():
	var msg = {"action": "end_turn"}
	WebSocketClient.send_message(JSON.stringify(msg))


func _on_sell_button_pressed(cell_id:int):
	emit_signal("sell_property_clicked", cell_id)	

func _on_pop_up_offre_accept_offer_clicked() -> void:
	emit_signal("accept_offer_clicked")


func _on_quitter_la_partie_pressed() :
	quit_dialog.popup_centered() 
	


func _on_timer_timeout() -> void:
	print("Temps écoulé ! Fin de la partie.")
	quit_dialog.popup_centered() 


func _on_reglages_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/reglages.tscn")


func _on_quit_dialog_confirmed() -> void:
	get_tree().quit()


func _on_help_button_pressed():
	help_popup.show()  

func _on_sned_button_pressed():
	var name = name_edit.text
	var phone = phone_edit.text
	var email = email_edit.text
	var message = message_edit.text

	if name.is_empty() or email.is_empty() or message.is_empty():
		print("Veuillez remplir tous les champs obligatoires.")
		return
	
	print("Nom:", name)
	print("Téléphone:", phone)
	print("Email:", email)
	print("Message:", message)
