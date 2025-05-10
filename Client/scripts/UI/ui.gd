@tool
extends CanvasLayer 
class_name UI
signal end_turn_clicked
signal move_player_requested(steps)
signal accept_offer_clicked
signal sell_property_clicked(cell_id)
signal end_game

const GUEST_HUB = preload("res://scenes/UI/Hub/guest_hub.tscn")
@onready var dice:Dice = $Dice
@onready var main_player_hub:MainPlayerHub = $MainPlayerHub
@onready var popup_offer = $PopUpOffre
@onready var jail_offre = $PopUpJail
@onready var end_turn_btn: Button = $EndTurnButton
@onready var turn_lable:Label = $TurnLable
@onready var guest_hubs_container:VBoxContainer = $GuestHubContainer
@onready var info_message: Label = $Info/VBoxContainer/InfoMessage
@onready var event_card:EventCard = $EventCard
@onready var quit_dialog_panel = $quit_game
@onready var settings_panel = $Settings

func _ready() -> void:
	# Subscribe to signals
	#turn_lable.text = "Player's turn: " + States.players[States.id_player_at_turn].player_name
	dice.dice_rolled.connect(_on_dice_dice_rolled)
	end_turn_btn.pressed.connect(_on_end_turn_button_pressed)
	quit_dialog_panel.visible = false
	settings_panel.visible = false
	end_turn_btn.visible = false
	
func _on_dice_dice_rolled():
	if States.id_player_at_turn == UserData.user_id:
		end_turn_btn.visible = true
	else: 
		end_turn_btn.visible = false
	var msg = {"action": "dice_rolled", "for": States.current_context}
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

func _on_change_turn():
	end_turn_btn.visible = false
	turn_lable.text = "Player's turn: " + States.players[States.id_player_at_turn].player_name

func _on_end_turn_button_pressed():
	emit_signal("end_turn_clicked")
	

func _on_pop_up_offre_accept_offer_clicked() -> void:
	emit_signal("accept_offer_clicked")


func _on_menu_btn_pressed() -> void:
	#emit_signal("end_game")
	WebSocketClient.close_connection()
	get_tree().change_scene_to_file("res://scenes/Menu/home.tscn")
	
func show_info(info:String):
	info_message.text = info
	$Info.visible = true

func _on_ok_button_pressed() -> void:
	$Info.visible = false


func _on_setting_pressed() -> void:
	settings_panel.visible = !settings_panel.visible

	
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	quit_dialog_panel.visible = !quit_dialog_panel.visible
	
	pass # Replace with function body.
