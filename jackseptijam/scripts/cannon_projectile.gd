extends Projectile

@export var radius: float = 5.0

@onready var explosion = preload("res://objects/cannon_splode.tscn")

func on_hit_target():
	if has_hit:
		return
	
	has_hit = true
	
	for i: Enemy in get_tree().get_nodes_in_group("enemy"):
		if i.global_position.distance_to(target_enemy.global_position) <= radius and i.has_method("take_damage"):
			if i == target_enemy:
				i.take_damage(damage)
			else: i.take_damage(damage*0.75)
			if effect == Globals.ETypes.PLAGUE:
				i.give_plague(4.5)
			if effect == Globals.ETypes.FIRE:
				i.give_fire(1.5)
			
	StoatStash.play_sfx_3d(preload("res://assets/sound/cannonsplosion.wav"), target_enemy.global_position, 0.5)
	
	var ee = explosion.instantiate()
	get_parent().add_child(ee)
	ee.restart()
	ee.emitting = true
	ee.scale = Vector3(0.2,0.2,0.2)
	ee.global_position = target_enemy.global_position
	queue_free()
