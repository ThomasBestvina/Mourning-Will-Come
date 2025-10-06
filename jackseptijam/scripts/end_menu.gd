extends Control

var has_died = false

func _process(delta: float) -> void:
	if not has_died and get_parent().get_parent().player_health <= 0:
		StoatStash.animate_ui_slide_in(self, Vector2.DOWN, Vector2(0,-500), 0.4, Tween.TransitionType.TRANS_BOUNCE)
		visible = true
		has_died = true
		get_tree().paused = true
		var time: String = get_parent().get_node("TimeSpent").text
		$DiedFlavorText.text = "You have allowed too many\nto survive.\nTime Spent: " + time + "\n Enemies Killed: " + get_parent().get_parent().enemies_killed


func _on_resume_button_pressed() -> void:
	StoatStash.play_sfx(preload("res://assets/sound/ui_pressed.wav"),0.8)
	get_tree().paused = false
	StoatStash.restart_scene()


func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	StoatStash.play_sfx(preload("res://assets/sound/ui_pressed.wav"),0.8)
	StoatStash.change_scene_with_simple_transition("res://scenes/main_menu.tscn")
