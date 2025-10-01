extends Node3D


func _on_button_pressed() -> void:
	StoatStash.shake_3d($CharacterBody3D/Camera3D, 0.03, 2.0)
