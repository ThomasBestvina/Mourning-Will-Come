extends Control

func _ready() -> void:
	$VolumeSlider.value = StoatStash._sfx_volume*100

func _on_volume_slider_drag_ended(value_changed: bool) -> void:
	StoatStash.set_sfx_volume($VolumeSlider.value/100)
