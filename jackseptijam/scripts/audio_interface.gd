extends Control


func _ready() -> void:
	$SFX_Volume.value = StoatStash._sfx_volume*100
	$Music_Volume.value = StoatStash._music_volume*100
	$SfxCheckbox.button_pressed = !StoatStash._sfx_muted
	$MusicCheckbox.button_pressed = !StoatStash._music_muted

func _on_sfx_checkbox_toggled(toggled_on: bool) -> void:
	StoatStash.mute_sfx(!toggled_on)


func _on_music_checkbox_toggled(toggled_on: bool) -> void:
	StoatStash.mute_music(!toggled_on)

func _on_sfx_volume_drag_ended(value_changed: bool) -> void:
	StoatStash.set_sfx_volume(value_changed)


func _on_music_volume_drag_ended(value_changed: bool) -> void:
	StoatStash.set_sfx_volume(value_changed)
