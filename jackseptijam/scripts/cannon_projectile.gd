extends Projectile

@export var radius: float = 3.0

func on_hit_target():
	if has_hit:
		return
	
	has_hit = true
	
	for i: Enemy in get_tree().get_nodes_in_group("enemy"):
		if i.global_position.distance_to(target_enemy.global_position) <= radius and i.has_method("take_damage"):
			target_enemy.take_damage(damage)
			if effect == Globals.ETypes.PLAGUE:
				target_enemy.give_plague(4.5)
			if effect == Globals.ETypes.FIRE:
				target_enemy.give_fire(1.5)
	
	StoatStash.play_sfx_3d(preload("res://assets/sound/cannonsplosion.wav"), target_enemy.global_position, 0.5)
	
	queue_free()
