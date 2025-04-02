extends Node
var is_test: bool = false

var current_player_id: int = -1
var id_player_at_turn: int = 0

const DiceContext := {
	MOVE = "move",
	JAIL = "jail",
	UTILITY = "utility_rent",
	EVENT = "event",
	DOUBLE_ROLL = "double_roll"
}
var dice_active: bool = true
var current_context: String = "move"
