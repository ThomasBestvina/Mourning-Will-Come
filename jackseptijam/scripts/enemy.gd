extends PathFollow3D
class_name Enemy

signal enemy_win

signal died

@export var speed = 2.0
@export var health = 10.0
@export var strength_score = 1.0

var modifier_stack = []

func _process(delta: float) -> void:
	set_progress(get_progress() + speed * delta)
	if health <= 0:
		emit_signal("died")
		queue_free()
	
	if(get_progress_ratio() >= 0.99):
		emit_signal("enemy_win")
		queue_free()

func take_damage(damage: float):
	health -= damage
