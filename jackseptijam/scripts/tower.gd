extends Node3D
class_name Tower

signal selected(obj: Node3D)
signal deselected(obj: Node3D)

var game: Game

enum targetting_mode {STRONGEST, NEAREST, LAST, FIRST}

@export var target_mode: targetting_mode = targetting_mode.NEAREST
@export var spawn_point: Node3D
@export var fire_range: float = 8
@export var projectile_scene: PackedScene
@export var cooldown: float = 1.2
@export var damage: float = 3.0
@export var range_display_mesh: MeshInstance3D

var enemylist = []

var target: Enemy

var secondary = Globals.ETypes.WOOD

var did_call: bool = false

var hovered: bool = false
var is_selected: bool = false

var is_placed: bool = false

var is_on_ground: bool = false

func _ready() -> void:
	$RangeDisplayMesh.mesh = $RangeDisplayMesh.mesh.duplicate()
	$RangeDisplayMesh.mesh.top_radius = fire_range
	$RangeDisplayMesh.mesh.bottom_radius = fire_range
	$RangeDisplayMesh.show()

func place():
	is_placed = true
	range_display_mesh.visible = false
	if(secondary == Globals.ETypes.CANDY):
		await StoatStash.repeat_call(shoot, cooldown-cooldown/20)
	else:
		await StoatStash.repeat_call(shoot, cooldown)
	await StoatStash.repeat_call(choose_target, 0.2)

func _process(delta: float) -> void:
	if target == null or target.global_position.distance_squared_to(global_position) >= fire_range**2: 
		target = choose_target()
	
	if hovered and Input.is_action_just_pressed("place_tower") and get_viewport().gui_get_hovered_control() == null:
		emit_signal("selected", self)
		is_selected = true
	if not hovered and Input.is_action_just_pressed("place_tower") and get_viewport().gui_get_hovered_control() == null:
		emit_signal("deselected",self)
		is_selected = false

	is_on_ground = $RayCast3D.is_colliding() and $RayCast3D.get_collider().is_in_group("ground")
	
	$RangeDisplayMesh.visible = hovered or is_selected or not is_placed

func shoot():
	if(target == null): return
	var projectile: Projectile = projectile_scene.instantiate()
	get_parent().add_child(projectile)
	projectile.effect = secondary
	projectile.setup_projectile(spawn_point.global_position,target)
	projectile.damage = damage
	if(secondary == Globals.ETypes.METAL):
		projectile.damage += damage / 4

func choose_target():
	var possibilities = get_tree().get_nodes_in_group("enemy")
	enemylist.clear()
	for enemy: Enemy in possibilities:
		if enemy.global_position.distance_squared_to(global_position) < fire_range**2:
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
