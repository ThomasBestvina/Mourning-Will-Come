extends Node

enum ETypes {WOOD, PLAGUE, FIRE, METAL, CANDY}

var game_paused: bool = false
var wave_paused: bool = false

var first_boss_spawned: bool = false

func _enter_tree() -> void:
	StoatStash.set_sfx_volume(0.8)
	StoatStash.set_music_volume(0.8)
