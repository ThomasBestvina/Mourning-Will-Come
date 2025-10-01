extends PathFollow3D
class_name Enemy

signal enemy_win

@export var speed = 2.0

@export var strength_score = 1.0

func _process(delta: float) -> void:
	set_progress(get_progress() + speed * delta)
	
	if(get_progress_ratio() >= 0.99):
		emit_signal("enemy_win")
		queue_free()
