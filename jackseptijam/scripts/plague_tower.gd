extends Node3D
class_name Plague

signal selected(obj: Node3D)
signal deselected(obj: Node3D)

@export var fire_range = 4.0
@export var cooldown = 3.0
@export var plague_duration = 8.0

var game: Game
var secondary = Globals.ETypes.WOOD

var hovered: bool = false
var is_selected: bool = false
var is_placed: bool = false
var is_on_ground = false

var grade: int = 1

@onready var chevrons = preload("res://objects/upgrade_chevron.tscn")

func _ready() -> void:
	add_to_group("tower")
	if secondary == Globals.ETypes.WOOD:
		fire_range *= 1.25
	if secondary == Globals.ETypes.CANDY:
		cooldown = cooldown * 0.75
	if secondary == Globals.ETypes.PLAGUE:
		cooldown = cooldown * 0.85
		fire_range *= 1.10
	
	$StaticBody3D/CollisionShape3D.disabled = true
	$RangeDisplayMesh.mesh = $RangeDisplayMesh.mesh.duplicate()
	$RangeDisplayMesh.mesh.inner_radius = fire_range-0.2
	$RangeDisplayMesh.mesh.outer_radius = fire_range
	$RangeDisplayMesh.show()
	$RangeDisplayMeshRed.mesh = $RangeDisplayMeshRed.mesh.duplicate()
	$RangeDisplayMeshRed.mesh.inner_radius = fire_range-0.2
	$RangeDisplayMeshRed.mesh.outer_radius = fire_range
	$RangeDisplayMeshRed.show()
	var lst = [$Cube, $Cube_001, $Cube_002]
	for i in lst:
		i.set_surface_override_material(0,i.get_active_material(0).duplicate())
		match secondary:
			Globals.ETypes.WOOD:
				i.get_surface_override_material(0).set_texture(0, preload("res://assets/3d/towers/placeHolderBallista_woodPallete.png"))
			Globals.ETypes.PLAGUE:
				i.get_surface_override_material(0).set_texture(0, preload("res://assets/3d/towers/placeHolderPlague_Plague.png"))
			Globals.ETypes.FIRE:
				i.get_surface_override_material(0).set_texture(0, preload("res://assets/2d/textures/Palletes/firePallette.png"))
			Globals.ETypes.METAL:
				i.get_surface_override_material(0).set_texture(0, preload("res://assets/2d/textures/Palletes/metalPallette.png"))
			Globals.ETypes.CANDY:
				i.get_surface_override_material(0).set_texture(0, preload("res://assets/2d/textures/Palletes/candyPallette.png"))

func _process(delta: float) -> void:
	$Chevrons.visible = $RangeDisplayMesh.visible or $RangeDisplayMeshRed.visible
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


func is_near_other_tower() -> bool:
	for i: Node3D in get_tree().get_nodes_in_group("tower"):
		if i != self and i.global_position.distance_squared_to(global_position) <= 2.5:
			return true
	return false

func place():
	$StaticBody3D/CollisionShape3D.disabled = false
	is_placed = true
	$RangeDisplayMesh.visible = false
	await StoatStash.repeat_call(fire, cooldown)

func fire():
	$PlagueParticle.restart()
	for enemy: Enemy in get_tree().get_nodes_in_group("enemy"):
		if enemy.global_position.distance_squared_to(global_position) <= fire_range**2:
			enemy.give_plague(plague_duration+grade/2.0)
			if secondary == Globals.ETypes.FIRE:
				enemy.give_fire(1.5)
			if secondary == Globals.ETypes.METAL:
				enemy.take_damage(2+grade/4.0)
	$PlagueParticle.emitting = true
	StoatStash.play_sfx_3d(preload("res://assets/sound/plaguetower_fire.wav"), global_position, 0.6)


func upgrade():
	grade += 1
	fire_range += 0.4
	$RangeDisplayMesh.mesh.inner_radius = fire_range-0.1
	$RangeDisplayMesh.mesh.outer_radius = fire_range
	$RangeDisplayMeshRed.mesh.inner_radius = fire_range-0.1
	$RangeDisplayMeshRed.mesh.outer_radius = fire_range
	add_chevron()

func add_chevron():
	var cc = chevrons.instantiate()
	$Chevrons.add_child(cc)
	cc.position += Vector3(0,0,0.8-grade/3.5)

func _on_static_body_3d_mouse_entered() -> void:
	hovered = true


func _on_static_body_3d_mouse_exited() -> void:
	hovered = false

func sell(percent):
	game.amount_plague += game.PLAGUE_COST_PRIMARY * percent
	
	match secondary:
		Globals.ETypes.WOOD:
			game.amount_wood += game.WOOD_COST_SECONDARY * percent
		Globals.ETypes.FIRE:
			game.amount_fire += game.FIRE_COST_SECONDARY * percent
		Globals.ETypes.METAL:
			game.amount_metal += game.METAL_COST_SECONDARY * percent
		Globals.ETypes.PLAGUE:
			game.amount_plague += game.PLAGUE_COST_SECONDARY * percent
		Globals.ETypes.CANDY:
			game.amount_candy += game.CANDY_COST_SECONDARY * percent
	
	if(game.selected_tower == self):
		game.selected_tower = null
	
	queue_free()
