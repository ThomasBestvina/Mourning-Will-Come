extends Node3D

enum targetting_mode {STRONGEST, NEAREST, LAST, FIRST}

@export var target_mode: targetting_mode

@export var range: float = 8

var enemylist = []

var target: Enemy

func _ready() -> void:
	$target_area/CollisionShape3D.shape = $target_area/CollisionShape3D.shape.duplicate()
	$RangeDisplayMesh.mesh = $RangeDisplayMesh.mesh.duplicate()
	$target_area/CollisionShape3D.shape.radius = range
	$RangeDisplayMesh.mesh.top_radius = range
	$RangeDisplayMesh.mesh.bottom_radius = range

func _process(delta: float) -> void:
	choose_target()
	if target == null: return


func choose_target():
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

func get_strongest():
	var strongest: Enemy = enemylist[0]
	for enemy: Enemy in enemylist:
		if(enemy.strength_score > strongest.strength_score):
			strongest = enemy
	return strongest

func get_nearest():
	var nearest: Enemy = enemylist[0]
	for enemy: Enemy in enemylist:
		if(enemy.global_position.distance_squared_to(global_position) < enemy.global_position.distance_squared_to(global_position)):
			nearest = enemy
	return nearest

func get_last():
	var last: Enemy = enemylist[0]
	for enemy: Enemy in enemylist:
		if(enemy.progress_ratio < last.progress_ratio):
			last = enemy
	return last

func get_first():
	var first: Enemy = enemylist[0]
	for enemy: Enemy in enemylist:
		if(enemy.progress_ratio > first.progress_ratio):
			first = enemy
	return first

func _on_target_area_body_entered(body: Node3D) -> void:
	if(body is Enemy):
		enemylist.append(body)


func _on_target_area_body_exited(body: Node3D) -> void:
	if(body is Enemy and enemylist.has(body)):
		enemylist.erase(body)
