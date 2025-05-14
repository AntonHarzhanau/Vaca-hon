extends AudioStreamPlayer
const level_music = preload("res://audio/music/World 4 Map - New Super Mario Bros. Wii Music Extended.mp3")

func _play_music(music: AudioStream, volume: float = 1.0) -> void:
	if stream == music:
		return
	stream = music
	var min_db = -70.0
	var max_db = 6.0
	volume_db = lerp(min_db, max_db, volume)  
	play()

func paly_music_level():
	_play_music(level_music)
