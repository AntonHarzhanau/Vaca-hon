# AudioManager.gd
extends Node

# BGM and SFX buses
@export var bgm_bus := "BGM"
@export var sfx_bus := "SFX"

var bgm_player: AudioStreamPlayer
var sfx_player: AudioStreamPlayer
var current_bgm: AudioStream = null

# Volume settings
var bgm_volume := 0.8
var sfx_volume := 0.8

func _ready():
	# Create audio players
	bgm_player = AudioStreamPlayer.new()
	sfx_player = AudioStreamPlayer.new()
	bgm_player.playback_type = AudioServer.PLAYBACK_TYPE_STREAM
	sfx_player.playback_type = AudioServer.PLAYBACK_TYPE_STREAM
	bgm_player.bus = bgm_bus
	sfx_player.bus = sfx_bus
	add_child(bgm_player)
	add_child(sfx_player)

	# Set initial volume
	bgm_volume = UserData.bgm_volume
	sfx_volume = UserData.sfx_volume
	update_volumes()

func update_volumes():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bgm_bus), linear_to_db(bgm_volume))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(sfx_bus), linear_to_db(sfx_volume))

func set_bgm_volume(value: float):
	bgm_volume = value
	update_volumes()
	UserData.bgm_volume = bgm_volume
	UserData.save_user_data()
	print("Change BGM volume to : ", value)

func set_sfx_volume(value: float):
	sfx_volume = value
	update_volumes()
	UserData.sfx_volume = sfx_volume
	UserData.save_user_data()
	print("Change SFX volume to : ", value)

func play_bgm(stream: AudioStream):
	if current_bgm == stream:
		return
	current_bgm = stream
	bgm_player.stream = stream
	bgm_player.play()

func stop_bgm():
	bgm_player.stop()
	bgm_player.volume_db = 0  # Reset for next play
	current_bgm = null

func play_sfx(stream: AudioStream):
	sfx_player.stream = stream
	sfx_player.play()
	
func fade_out_bgm(duration: float = 1.0):
	if not bgm_player.playing:
		return  # No music to fade out

	var tween := create_tween()
	tween.tween_property(bgm_player, "volume_db", -80, duration)
	tween.tween_callback(Callable(self, "stop_bgm"))
