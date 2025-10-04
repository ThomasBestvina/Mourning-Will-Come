extends Control


func _on_play_pressed() -> void:
	StoatStash.change_scene_with_simple_transition("res://scenes/game.tscn", 1.0)
