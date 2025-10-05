extends Control

func _ready() -> void:
	StoatStash.play_music(preload("res://assets/music/main menu.wav"), 1.0)

func _on_play_pressed() -> void:
	StoatStash.change_scene_with_simple_transition("res://scenes/game.tscn", 1.0)
	StoatStash.play_sfx(preload("res://assets/sound/ui_pressed.wav"),0.8)


func _on_credits_pressed() -> void:
	StoatStash.play_sfx(preload("res://assets/sound/ui_pressed.wav"),0.8)


func _on_quit_pressed() -> void:
	StoatStash.play_sfx(preload("res://assets/sound/ui_pressed.wav"),0.8)


func _on_options_pressed() -> void:
	StoatStash.change_scene("res://scenes/options.tscn")
