extends Node
var is_test: bool = false

var id_player_at_turn: int = 0
var lobby_id: int = 0
var lobby_max_players: int = 4
var lobby_owner_id: int = 0

var players:Dictionary[int, Player]= {}
var users := []
var available_tokens = []

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

const DEFAULT_HTTP_BASE_URL = "https://api.vacashon.online"
const DEFAULT_WS_BASE_URL = "wss://api.vacashon.online/ws/join"
#const DEFAULT_HTTP_BASE_URL = "http://127.0.0.1:8000"
#const DEFAULT_WS_BASE_URL = "ws://127.0.0.1:8000/ws/join"

var HTTP_BASE_URL = DEFAULT_HTTP_BASE_URL
var WS_BASE_URL = DEFAULT_WS_BASE_URL

func set_addres(adress:String, port:String):
	HTTP_BASE_URL = adress+":" +port+ "/ws/join"
	WS_BASE_URL = adress+":" + port
