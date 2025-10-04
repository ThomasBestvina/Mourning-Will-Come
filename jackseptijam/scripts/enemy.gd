extends PathFollow3D
class_name Enemy

signal enemy_win(points)

signal died(type, amount)

@export var fire_placement: Node3D

@export_category("Properties")
@export var max_speed = 2.0
var speed = 2.0
@export var max_health = 10.0
var health = 10.0
@export var strength_score = 1.0

@export_category("Drops and Death")
@export var points: int = 1
@export var type: Globals.ETypes = Globals.ETypes.WOOD
@export var max_drops = 1
@export var drop_chance = 0.7


@onready var plague_preload = preload("res://objects/has_plague.tscn")
var plague_particles: CPUParticles3D

@onready var fire_preload = preload("res://objects/has_fire.tscn")
var fire_particles: CPUParticles3D


@onready var pickable_drop = preload("res://objects/pickable_resource.tscn")
@export var drop_upward_force = 5.0
@export var drop_random_force = 2.0

# modifiers are just arrays [mod_type, duration]
var modifier_stack = {
	"plague": 0,
	"fire": 0
}

func _ready() -> void:
	health += get_parent().get_parent().current_difficulty*2
	plague_particles = plague_preload.instantiate()
	add_child(plague_particles)
	plague_particles.emitting = false
	
	fire_particles = fire_preload.instantiate()
	add_child(fire_particles)
	fire_particles.emitting = false
	
	health = max_health
	speed = max_speed

func _process(delta: float) -> void:
	fire_particles.global_position = fire_placement.global_position
	set_progress(get_progress() + speed * delta)
	if health <= 0:
		var drops = 0
		for i in max_drops:
			if(StoatStash.chance(drop_chance/ min(get_parent().get_parent().current_difficulty/10,1)) ):
				drops += 1
		emit_signal("died", type, drops)
		spawn_drops(drops, false)
		if(StoatStash.chance(0.05)):
			spawn_drops(1, true)
		StoatStash.play_sfx_3d(preload("res://assets/sound/enemydie.wav"), global_position)
		queue_free()
	
	if(get_progress_ratio() >= 0.99):
		emit_signal("enemy_win", points)
		queue_free()


func _physics_process(delta: float) -> void:
	if modifier_stack["plague"] > 0:
		if StoatStash.chance(0.03):
			take_damage(max_health/30)
		modifier_stack["plague"] -= delta
		speed = max_speed - max_speed / 4
	else:
		speed = max_speed
	if modifier_stack["fire"] > 0:
		if StoatStash.chance(0.05):
			take_damage(1)
		modifier_stack["fire"] -= delta
	
	plague_particles.emitting = modifier_stack["plague"] > 0
	fire_particles.emitting = modifier_stack["fire"] > 0

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
		drop.setup(type,musket)

func give_plague(seconds):
	modifier_stack["plague"] += seconds 

func give_fire(seconds):
	modifier_stack["fire"] += seconds

func take_damage(damage: float):
	health -= damage
