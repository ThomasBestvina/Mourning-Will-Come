extends Control


@onready var game: Game = get_parent()
@onready var key_sprite = preload("res://objects/key.tscn")

func _ready() -> void:
	$VolumeSlider.value = StoatStash._sfx_volume*100

func _on_volume_slider_drag_ended(value_changed: bool) -> void:
	StoatStash.set_sfx_volume($VolumeSlider.value/100)


var keys: Dictionary = {}

func _process(delta: float) -> void:
	for key in keys.keys():
		if !is_instance_valid(key):
			keys[key].queue_free()
			keys.erase(key)

	for path in game.get_node("Prim").get_children() + game.get_node("Second").get_children():
		if not path is PathFollow3D: return
		var i: PathFollow3D = path
		if not keys.has(i):
			var kk = key_sprite.instantiate()
			add_child(kk)
			keys[i] = kk

		keys[i].global_position = Vector2(238,20) + Vector2(i.progress_ratio*620,0)
