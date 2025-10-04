extends Node3D

func _ready() -> void:
	$Explosion.frame = 0
	$Explosion.play()

func _on_explosion_animation_looped() -> void:
	queue_free()
