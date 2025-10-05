extends Node3D
class_name Tower

signal selected(obj: Node3D)
signal deselected(obj: Node3D)

var game: Game

enum targetting_mode {STRONGEST, NEAREST, LAST, FIRST}

@export var target_mode: targetting_mode = targetting_mode.FIRST
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

var can_fire = true

var grade: int = 1

func _ready() -> void:
	add_to_group("tower")
	StoatStash.safe_signal_connect($Timer.timeout, _on_timer_timeout)
	if secondary == Globals.ETypes.WOOD:
		fire_range *= 1.25
	if($RangeDisplayMesh.mesh):
		$RangeDisplayMesh.mesh = $RangeDisplayMesh.mesh.duplicate()
		$RangeDisplayMesh.mesh.inner_radius = fire_range-0.2
		$RangeDisplayMesh.mesh.outer_radius = fire_range
		$RangeDisplayMesh.show()
		$RangeDisplayMeshRed.mesh = $RangeDisplayMeshRed.mesh.duplicate()
		$RangeDisplayMeshRed.mesh.inner_radius = fire_range-0.2
		$RangeDisplayMeshRed.mesh.outer_radius = fire_range
		$RangeDisplayMeshRed.show()

func place():
	is_placed = true
	range_display_mesh.visible = false
	if(secondary == Globals.ETypes.CANDY):
		await StoatStash.repeat_call(shoot, cooldown-cooldown/20)
	else:
		await StoatStash.repeat_call(shoot, cooldown)
	await StoatStash.repeat_call(choose_target, 0.1)

func _process(delta: float) -> void:
	if target == null or target.global_position.distance_squared_to(global_position) >= fire_range**2: 
		choose_target()
	
	if target != null:
		shoot()
	
	
	if hovered and Input.is_action_just_pressed("place_tower") and get_viewport().gui_get_hovered_control() == null:
		emit_signal("selected", self)
		is_selected = true
	if not hovered and Input.is_action_just_pressed("place_tower") and get_viewport().gui_get_hovered_control() == null:
		emit_signal("deselected",self)
		is_selected = false
	
	is_on_ground = not is_placed and $RayCast3D.is_colliding() and $RayCast3D2.is_colliding() and $RayCast3D3.is_colliding() and $RayCast3D4.is_colliding() and $RayCast3D.get_collider().is_in_group("ground") and $RayCast3D2.get_collider().is_in_group("ground") and $RayCast3D3.get_collider().is_in_group("ground") and $RayCast3D4.get_collider().is_in_group("ground") and not is_near_other_tower()
	
	if hovered or is_selected or not is_placed:
		if is_on_ground:
			$RangeDisplayMesh.show()
			$RangeDisplayMeshRed.hide()
		else:
			$RangeDisplayMesh.hide()
			$RangeDisplayMeshRed.show()
	else:
		$RangeDisplayMesh.hide()
		$RangeDisplayMeshRed.hide()

func upgrade():
	grade += 1
	fire_range += 0.2
	if($RangeDisplayMesh.mesh):
		$RangeDisplayMesh.mesh.inner_radius = fire_range-0.2
		$RangeDisplayMesh.mesh.outer_radius = fire_range
		$RangeDisplayMeshRed.mesh.inner_radius = fire_range-0.2
		$RangeDisplayMeshRed.mesh.outer_radius = fire_range


func is_near_other_tower() -> bool:
	for i: Node3D in get_tree().get_nodes_in_group("tower"):
		if i != self and i.global_position.distance_squared_to(global_position) <= 2.5:
			return true
	return false

func shoot():
	if(target == null or not can_fire or not is_placed):
		return
	StoatStash.play_sfx_3d(preload("res://assets/sound/TurretFire.wav"), global_position, 0.9, 0.5)
	var projectile: Projectile = projectile_scene.instantiate()
	get_parent().add_child(projectile)
	projectile.effect = secondary
	projectile.setup_projectile(spawn_point.global_position,target)
	if(secondary == Globals.ETypes.METAL):
		projectile.damage = projectile.damage * 1.25 + grade
	can_fire = false
	$Timer.start(cooldown - grade/4)

func choose_target():
	var possibilities = get_tree().get_nodes_in_group("enemy")
	enemylist.clear()
	for enemy: Enemy in possibilities:
		if enemy.global_position.distance_to(global_position) < fire_range:
			enemylist.append(enemy)
		
	if(enemylist.is_empty()): 
		target = null
		return
	
	match target_mode:
		targetting_mode.STRONGEST:
			target = get_strongest()
		targetting_mode.NEAREST:
			target = get_nearest()
		targetting_mode.LAST:
			target = get_last()
		targetting_mode.FIRST:
			target = get_first()

func get_strongest() -> Enemy:
	var strongest: Enemy = enemylist[0]
	for enemy: Enemy in enemylist:
		if(enemy.max_health > strongest.max_health):
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


func _on_timer_timeout() -> void:
	can_fire = true
