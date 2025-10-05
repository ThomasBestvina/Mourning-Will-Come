extends Control


func _ready() -> void:
	visible = false
	$SFX_Volume.value = StoatStash._sfx_volume*100
	$Music_Volume.value = StoatStash._music_volume*100
	$SfxCheckbox.button_pressed = !StoatStash._sfx_muted
	$MusicCheckbox.button_pressed = !StoatStash._sfx_muted

func _on_sfx_checkbox_toggled(toggled_on: bool) -> void:
	if(visible):
		StoatStash.mute_sfx(!toggled_on)
		StoatStash.play_sfx(preload("res://assets/sound/ui_pressed.wav"),0.8)
		print(toggled_on)

func _on_music_checkbox_toggled(toggled_on: bool) -> void:
	if visible:
		StoatStash.play_sfx(preload("res://assets/sound/ui_pressed.wav"),0.8)
		StoatStash.mute_music(!toggled_on)

func _on_sfx_volume_drag_ended(value_changed: bool) -> void:
	if visible:
		StoatStash.set_sfx_volume($SFX_Volume.value/100)
		StoatStash.play_sfx(preload("res://assets/sound/ui_pressed.wav"),0.8)


func _on_music_volume_drag_ended(value_changed: bool) -> void:
	if visible:
		StoatStash.play_sfx(preload("res://assets/sound/ui_pressed.wav"),0.8)
		StoatStash.set_music_volume($Music_Volume.value/100)
