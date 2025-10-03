extends Tower

func _ready() -> void:
	$Selector/CollisionShape3D.disabled = true
	super._ready()
	var lst = [$Rotator/BallDetail2, $Rotator/BallDetails, $Rotator/Body, $Rotator/Eyes, $Rotator/Fuse, $Rotator/Eyes, $Rotator/Fuse, $Platform, $Legs]
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
