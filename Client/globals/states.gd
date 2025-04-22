extends Node
var is_test: bool = false

var id_player_at_turn: int = 0
var lobby_id: int = 0

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
#var BASE_URL = "ws://127.0.0.1:8000/ws/join/"
var BASE_URL = "ws://173.249.34.12:8000/ws/join/"
#var URL = "ws://127.0.0.1:8000/ws/join/"
var URL = "ws://173.249.34.12:8000/ws/join/"
#var HTTP_URL = "http://127.0.0.1:8000"
var HTTP_URL = "http://173.249.34.12:8000"

func set_addres(adress:String, port:String):
	BASE_URL = "ws://" +adress+":" +port+ "/ws/join/"
	HTTP_URL = "http://"+adress+":" + port
func set_url(lobby_id:int, user_id:int):
	URL = BASE_URL
	URL = URL+str(lobby_id)+"?user_id="+str(user_id)
