extends Control

func _input(event):
	if event.is_action_pressed("pause"):
		get_tree().paused = !get_tree().paused


func _process(delta: float) -> void:
	visible = get_tree().paused
