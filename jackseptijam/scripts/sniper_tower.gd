extends Tower
class_name Sniper
func _ready() -> void:
	$Selector/CollisionShape3D.disabled = true
	super._ready()
	$RangeDisplayMesh.mesh.top_radius = 1.0
	$RangeDisplayMesh.mesh.bottom_radius = 1.0
	$RangeDisplayMeshRed.mesh.top_radius = 1.0
	$RangeDisplayMeshRed.mesh.bottom_radius = 1.0
	var lst = [$Rotator/gunBase, $Rotator/scope, $Rotator/scopeConnector, $Rotator/pillarSmall, $Rotator/smallGear2, $Rotator/smallGear1, $PillarTop, $pillarBottom, $base, $mediumGear, $bigGear, $bigGear2]
	for i in lst:
		i.set_surface_override_material(0,i.get_active_material(0).duplicate())
		match secondary:
			Globals.ETypes.WOOD:
				i.get_surface_override_material(0).set_texture(0, preload("res://assets/3d/towers/placeHolderBallista_woodPallete.png"))
			Globals.ETypes.PLAGUE:
				i.get_surface_override_material(0).set_texture(0, preload("res://assets/3d/towers/placeHolderPlague_Plague.png"))
			Globals.ETypes.FIRE:
				i.get_surface_override_material(0).set_texture(0, preload("res://assets/3d/towers/cannon_firePallette.png"))
			Globals.ETypes.METAL:
				i.get_surface_override_material(0).set_texture(0, preload("res://assets/3d/towers/sniper_metalPallette.png"))
			Globals.ETypes.CANDY:
				i.get_surface_override_material(0).set_texture(0, preload("res://assets/3d/towers/candyCornMG_candyPallette.png"))

func place():
	super.place()
	$Selector/CollisionShape3D.disabled = false

func _process(delta: float) -> void:
	super._process(delta)
	if target:
		$Rotator.look_at(target.global_position)
		$Rotator.rotation.x = 0
		$Rotator.rotation.z = 0


func _on_selector_mouse_entered() -> void:
	hovered = true

func _on_selector_mouse_exited() -> void:
	hovered = false

func sell(percent):
	game.amount_metal += game.METAL_COST_PRIMARY * percent
	
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
