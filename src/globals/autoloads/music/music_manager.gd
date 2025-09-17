extends Node


@onready var music_player:AudioStreamPlayer = $MusicPlayer


func song_request(song: StringName) -> void:
	if (not music_player.playing) or not music_player.has_stream_playback():
		# Sanity check- As far as I know this should never happen.
		push_error("Music player is dead, restarting..")
		music_player.play()
		await get_tree().process_frame
	var playback: AudioStreamPlaybackInteractive = music_player.get_stream_playback()
	if song == music_player.stream.get_clip_name(playback.get_current_clip_index()):
		return

	playback.switch_to_clip_by_name(song)
