extends Control


func _on_main_menu_button_pressed() -> void:
	StoatStash.play_sfx(preload("res://assets/sound/ui_pressed.wav"),0.8)
	StoatStash.change_scene("res://scenes/main_menu.tscn")
