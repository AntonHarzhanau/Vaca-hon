extends Node
var is_test: bool = false

var id_player_at_turn: int = 0
var lobby_id: int = 0

var players:Dictionary[int, Player]= {}

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

const DEFAULT_HTTP_BASE_URL = "https://185.155.93.105:20008"
const DEFAULT_WS_BASE_URL = "wss://185.155.93.105:20008/ws/join"

var HTTP_BASE_URL = DEFAULT_HTTP_BASE_URL
var WS_BASE_URL = DEFAULT_WS_BASE_URL

func set_addres(adress:String, port:String):
	HTTP_BASE_URL = adress+":" +port+ "/ws/join"
	WS_BASE_URL = adress+":" + port
