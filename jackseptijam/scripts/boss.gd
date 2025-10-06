extends Enemy

var drop_types = [Globals.ETypes.CANDY, Globals.ETypes.WOOD, Globals.ETypes.METAL, Globals.ETypes.FIRE, Globals.ETypes.PLAGUE]

func _ready() -> void:
	if (!Globals.first_boss_spawned):
		StoatStash.shake_3d(get_parent().get_parent().get_node("CharacterBody3D/Camera3D"), 0.06, 2)
		StoatStash.play_sfx(preload("res://assets/sound/boss_summon.wav"), 0.8)
		Globals.first_boss_spawned = true
	
	if(anim_player):
		anim_player.play(walk_string)
		StoatStash.safe_signal_connect(anim_player.animation_finished, anim_finished)
	
	health_display = healthbar_display_preload.instantiate()
	add_child(health_display)
	health_display.top_level = true
	
	max_health += max(get_parent().get_parent().current_difficulty-3,0)*6.4
	
	plague_particles = plague_preload.instantiate()
	add_child(plague_particles)
	plague_particles.restart()
	plague_particles.scale = Vector3(2.3,2.3,2.3)
	plague_particles.emitting = true
	
	fire_particles = fire_preload.instantiate()
	add_child(fire_particles)
	fire_particles.scale = Vector3(2.3,2.3,2.3)
	fire_particles.restart()
	fire_particles.emitting = true
	
	health = max_health
	speed = max_speed

func _process(delta: float) -> void:
	super._process(delta)
	look_at(get_parent().get_parent().get_node("CharacterBody3D").global_position)
	rotation.x = 0
	rotation.z = 0

func _physics_process(delta: float) -> void:
	if modifier_stack["plague"] > 0:
		if StoatStash.chance(0.03):
			take_damage(max_health/400)
		modifier_stack["plague"] -= delta
		speed = max_speed - max_speed / 4
	else:
		speed = max_speed
	if modifier_stack["fire"] > 0:
		if StoatStash.chance(0.05):
			take_damage(1)
		modifier_stack["fire"] -= delta
	
	plague_particles.visible = modifier_stack["plague"] > 0
	fire_particles.visible = modifier_stack["fire"] > 0

func spawn_drops(amount: int, musket: bool):
	for i in amount:
		var drop: RigidBody3D = pickable_drop.instantiate()
		
		get_tree().root.add_child(drop)
		
		drop.global_position = global_position
		
		var random_dir = Vector3(
			randf_range(-1,1),
			0,
			randf_range(-1, 1)
		).normalized()
		
		var throw_force = Vector3(
			random_dir.x * drop_random_force,
			drop_upward_force,
			random_dir.z * drop_random_force
		)
		drop.apply_central_impulse(throw_force)
		drop.game = get_parent().get_parent()
		drop.setup(drop_types[randi() % drop_types.size()],musket)

func die():
	var dd = death_explosion.instantiate()
	get_parent().add_child(dd)
	dd.global_position = fire_placement.global_position
	dd.restart()
	dd.scale = Vector3(0.2*2.5,0.2*2.5,0.2*2.5)
	dd.emitting = true
	StoatStash.delayed_call(dd.queue_free, 3)
	queue_free()
