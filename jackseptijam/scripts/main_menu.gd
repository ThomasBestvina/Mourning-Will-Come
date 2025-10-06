extends Control

func _ready() -> void:
	$PlagueParticle.emitting = true
	$HasFire.emitting = true
	$HasPlague.emitting = true
	$Explode.emitting = true
	$GPUParticles3D.emitting = true

func _on_play_pressed() -> void:
	StoatStash.change_scene_with_simple_transition("res://scenes/game.tscn", 1.0)
	StoatStash.play_sfx(preload("res://assets/sound/ui_pressed.wav"),0.8)


func _on_credits_pressed() -> void:
	StoatStash.play_sfx(preload("res://assets/sound/ui_pressed.wav"),0.8)
	StoatStash.change_scene("res://scenes/credits.tscn")


func _on_quit_pressed() -> void:
	StoatStash.play_sfx(preload("res://assets/sound/ui_pressed.wav"),0.8)
	get_tree().quit()


func _on_options_pressed() -> void:
	StoatStash.play_sfx(preload("res://assets/sound/ui_pressed.wav"),0.8)
	StoatStash.change_scene("res://scenes/options.tscn")
