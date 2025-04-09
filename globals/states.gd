extends Node
var is_test: bool = false

var current_player_id: int = -1
var id_player_at_turn: int = 0

const DiceContext := {
	MOVE = "move",
	JAIL = "jail",
	UTILITY = "utility_rent",
	EVENT = "event",
	DOUBLE_ROLL = "double_roll",
	GET_OUT_OF_JAIL = "get_out_of_jail"
}
var dice_active: bool = true
var current_context: String = "move"

var URL = "ws://127.0.0.1:8000/lobbies/ws"

func set_url(adress:String, port:String, prefix:String):
	URL = "ws://" +adress+":" +port+ "/"+prefix
