extends Node3D

@export var cooldown = 3.0
@export var plague_duration = 3.0

var secondary = Globals.ETypes.WOOD

func _ready() -> void:
	var lst = [$Cube, $Cube_001, $Cube_002]
	for i in lst:
		i.set_surface_override_material(0,i.get_active_material(0).duplicate())
		match secondary:
			Globals.ETypes.WOOD:
				i.get_surface_override_material(0).set_texture(0, preload("res://assets/3d/towers/placeHolderBallista_woodPallete.png"))
			Globals.ETypes.PLAGUE:
				i.get_surface_override_material(0).set_texture(0, preload("res://assets/3d/towers/placeHolderPlague_Plague.png"))


func place():
	$RangeDisplayMesh.visible = false
	await StoatStash.repeat_call(fire, cooldown)


func fire():
	for enemy: Enemy in get_tree().get_nodes_in_group("enemy"):
		enemy.modifier_stack.append(["plague", plague_duration])
