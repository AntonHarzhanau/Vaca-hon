extends CanvasLayer 
class_name UI
signal end_turn_clicked
signal move_player_requested(steps)
signal accept_offer_clicked
signal sell_property_clicked(cell_id)

const GUEST_HUB = preload("res://scenes/UI/Hub/guest_hub.tscn")
@onready var dice:Dice = $Dice
@onready var main_player_hub:MainPlayerHub = $MainPlayerHub
@onready var popup_offer = $PopUpOffre
@onready var end_turn_btn: Button = $EndTurnButton
@onready var turn_lable:Label = $TurnLable
@onready var guest_hubs_container:VBoxContainer = $GuestHubContainer

var id_player_on_turn: int = 0

func _ready() -> void:
	# Subscribe to signals
	turn_lable.text = "Player's turn: 0"
	dice.dice_rolled.connect(_on_dice_dice_rolled)
	end_turn_btn.pressed.connect(_on_end_turn_button_pressed)
	
func _on_dice_dice_rolled(d1: int, d2: int):
	#TODO: change logic
	var msg = {"action": "move_player", "steps": d1 + d2}
	WebSocketClient.send_message(JSON.stringify(msg))

func create_main_player_hub(player:Player):
	main_player_hub.set_player(player)
	main_player_hub.update_hub()

func create_guest_hub(player:Player):
	var guest_hub = GUEST_HUB.instantiate()
	guest_hub.player_id = player.id
	guest_hub.set_player(player)
	guest_hubs_container.add_child(guest_hub)
	guest_hub.update_hub()

func update_hubs(player:Player, current_player_id):
	print("hear")
	if player.id == current_player_id:
		main_player_hub.update_hub()
	else:
		for hub in guest_hubs_container.get_children():
			if player.id == hub.player_id:
				hub.update_hub()

func _on_player_disconnected(player_id):
	for hub in guest_hubs_container.get_children():
		if player_id == hub.player_id:
			hub.queue_free()

func _on_change_turn(player_id:int):
	id_player_on_turn = player_id
	turn_lable.text = "Player's turn: " + str(id_player_on_turn)

func _on_offer_to_buy(_cell_id, cell_name, price):
	popup_offer.show_offer(cell_name, price)

func _on_end_turn_button_pressed():
	var msg = {"action": "end_turn"}
	WebSocketClient.send_message(JSON.stringify(msg))

func _on_pop_up_offre_accept_offer_clicked() -> void:
	emit_signal("accept_offer_clicked")
