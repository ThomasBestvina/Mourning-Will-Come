extends Node3D
class_name Plague

signal selected(obj: Node3D)
signal deselected(obj: Node3D)

@export var fire_range = 4.0
@export var cooldown = 3.0
@export var plague_duration = 3.0

var game: Game
var secondary = Globals.ETypes.WOOD

var hovered: bool = false
var is_selected: bool = false
var is_placed: bool = false
var is_on_ground = false

func _ready() -> void:
	$StaticBody3D/CollisionShape3D.disabled = true
	$RangeDisplayMesh.mesh = $RangeDisplayMesh.mesh.duplicate()
	$RangeDisplayMesh.mesh.top_radius = fire_range
	$RangeDisplayMesh.mesh.bottom_radius = fire_range
	$RangeDisplayMesh.show()
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
	if hovered and Input.is_action_just_pressed("place_tower") and get_viewport().gui_get_hovered_control() == null:
		emit_signal("selected", self)
		is_selected = true
	if not hovered and Input.is_action_just_pressed("place_tower") and get_viewport().gui_get_hovered_control() == null:
		emit_signal("deselected",self)
		is_selected = false
	$RangeDisplayMesh.visible = hovered or is_selected or not is_placed
	is_on_ground = $RayCast3D.is_colliding() and $RayCast3D.get_collider().is_in_group("ground")
	

func place():
	$StaticBody3D/CollisionShape3D.disabled = false
	is_placed = true
	$RangeDisplayMesh.visible = false
	await StoatStash.repeat_call(fire, cooldown)


func fire():
	for enemy: Enemy in get_tree().get_nodes_in_group("enemy"):
		if enemy.global_position.distance_squared_to(global_position) <= fire_range**2:
			enemy.modifier_stack.append(["plague", plague_duration])


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
