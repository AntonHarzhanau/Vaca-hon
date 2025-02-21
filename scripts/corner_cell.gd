@tool
extends Cell
class_name CornerCell

var corner_type: String

func _ready():
	super._ready()
	
func activate(player):
	#use corner_type for indicate function for activate event
	pass

func activate_start_event(player):
	pass
func activate_jail_event(player):
	pass
func activate_parking_event(player):
	pass
func activate_go_to_jail_event(player):
	pass
