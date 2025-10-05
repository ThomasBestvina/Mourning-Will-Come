extends Control

func _input(event):
	if event.is_action_pressed("pause"):
		StoatStash.play_sfx(preload("res://assets/sound/ui_pressed.wav"),0.8)
		get_tree().paused = !get_tree().paused


func _process(delta: float) -> void:
	visible = get_tree().paused


func _on_resume_button_pressed() -> void:
	StoatStash.play_sfx(preload("res://assets/sound/ui_pressed.wav"),0.8)
	get_tree().paused = false


func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	StoatStash.play_sfx(preload("res://assets/sound/ui_pressed.wav"),0.8)
	StoatStash.change_scene_with_simple_transition("res://scenes/main_menu.tscn")
