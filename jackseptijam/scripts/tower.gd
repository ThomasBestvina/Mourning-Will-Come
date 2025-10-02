extends Node3D
class_name Tower

enum targetting_mode {STRONGEST, NEAREST, LAST, FIRST}

@export var target_mode: targetting_mode = targetting_mode.NEAREST
@export var spawn_point: Node3D
@export var fire_range: float = 8
@export var projectile_scene: PackedScene
@export var cooldown: float = 1.2
@export var damage: float = 3.0

var enemylist = []

var target: Enemy

var did_call: bool = false

func _ready() -> void:
	$RangeDisplayMesh.mesh = $RangeDisplayMesh.mesh.duplicate()
	$RangeDisplayMesh.mesh.top_radius = fire_range
	$RangeDisplayMesh.mesh.bottom_radius = fire_range
	
	await StoatStash.repeat_call(shoot, cooldown)
	

func _process(delta: float) -> void:
	if target == null or target.global_position.distance_squared_to(global_position) >= fire_range**2: 
		target = choose_target()

func shoot():
	if(target == null): return
	var projectile: Projectile = projectile_scene.instantiate()
	get_parent().add_child(projectile)
	projectile.setup_projectile(spawn_point.global_position,target)

func choose_target():
	var possibilities = get_tree().get_nodes_in_group("enemy")
	enemylist.clear()
	for enemy: Enemy in possibilities:
		if enemy.global_position.distance_squared_to(global_position) < fire_range*fire_range:
			enemylist.append(enemy)
	
	if(enemylist.is_empty()): 
		target = null
		return
	
	match target_mode:
		targetting_mode.STRONGEST:
			return get_strongest()
		targetting_mode.NEAREST:
			return get_nearest()
		targetting_mode.LAST:
			return get_last()
		targetting_mode.FIRST:
			return get_first()

func get_strongest() -> Enemy:
	var strongest: Enemy = enemylist[0]
	for enemy: Enemy in enemylist:
		if(enemy.strength_score > strongest.strength_score):
			strongest = enemy
	return strongest

func get_nearest() -> Enemy:
	var nearest: Enemy = enemylist[0]
	for enemy: Enemy in enemylist:
		if(enemy.global_position.distance_squared_to(global_position) < enemy.global_position.distance_squared_to(global_position)):
			nearest = enemy
	return nearest

func get_last() -> Enemy:
	var last: Enemy = enemylist[0]
	for enemy: Enemy in enemylist:
		if(enemy.progress_ratio < last.progress_ratio):
			last = enemy
	return last

func get_first() -> Enemy:
	var first: Enemy = enemylist[0]
	for enemy: Enemy in enemylist:
		if(enemy.progress_ratio > first.progress_ratio):
			first = enemy
	return first
