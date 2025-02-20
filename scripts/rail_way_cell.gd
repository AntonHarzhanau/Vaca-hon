@tool
extends PropertyCell
class_name RailWayCell

func _ready():
	super._ready()
	$BackGround/Image.pivot_offset = $BackGround/Image.size / 2
