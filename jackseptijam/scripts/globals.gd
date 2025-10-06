extends Node

enum ETypes {WOOD, PLAGUE, FIRE, METAL, CANDY}

var game_paused: bool = false
var wave_paused: bool = false

var first_boss_spawned: bool = false

var song: bool = false

func _enter_tree() -> void:
	StoatStash.set_sfx_volume(0.8)
	StoatStash.set_music_volume(0.8)
	StoatStash.play_music(preload("res://assets/music/main menu.wav"), 0.8)
	StoatStash.safe_signal_connect(StoatStash.current_music_finished, play_next)
	

func play_next():
	if song:
		StoatStash.play_music(preload("res://assets/music/main menu.wav"), 0.8)
	else:
		StoatStash.play_music(preload("res://assets/music/the second song.wav"), 0.8)
	
	song = !song
