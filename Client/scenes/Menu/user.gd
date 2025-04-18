extends Panel

@onready var userId: Label = $VBoxContainer/UserId
@onready var uname: Label = $VBoxContainer/UserName

var uid: int
var user_name:String

func _ready() -> void:
	userId.text = "UserID: " + str(uid)
	uname.text = "User name: " + user_name

func set_user(user_id: int, user_name:String):
	uid = user_id
	self.user_name = user_name
