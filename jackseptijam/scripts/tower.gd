extends Node3D

enum targetting_mode {STRONGEST, NEAREST, LAST, FIRST}

@export var target_mode: targetting_mode = targetting_mode.NEAREST

@export var range: float = 8

@export var cooldown: float = 1.2
@export var damage: float = 3.0

var enemylist = []

var target: Enemy

var did_call: bool = false

func _ready() -> void:
	$RangeDisplayMesh.mesh = $RangeDisplayMesh.mesh.duplicate()
	$RangeDisplayMesh.mesh.top_radius = range
	$RangeDisplayMesh.mesh.bottom_radius = range
	
	await StoatStash.repeat_call(shoot, cooldown)
	

func _process(delta: float) -> void:
	target = choose_target()
	if target == null: return

func shoot():
	print(target)
	if(target == null): return
	target.health -= damage
	print(target.health)

func choose_target():
	var possibilities = get_tree().get_nodes_in_group("enemy")
	enemylist.clear()
	for enemy: Enemy in possibilities:
		if enemy.global_position.distance_to(global_position) < range:
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
