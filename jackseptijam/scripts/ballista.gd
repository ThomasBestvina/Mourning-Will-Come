extends Tower

func _ready() -> void:
	super._ready()
	var lst = [$rotator,$rotator/Cube_003,$rotator/Cube_004,$Cube,$Cube_001]
	for i in lst:
		i.set_surface_override_material(0,i.get_active_material(0).duplicate())
		match secondary:
			Globals.WOOD:
				i.get_surface_override_material(0).set_texture(0, preload("res://assets/3d/towers/placeHolderBallista_woodPallete.png"))
			Globals.PLAGUE:
				i.get_surface_override_material(0).set_texture(0, preload("res://assets/3d/towers/placeHolderPlague_Plague.png"))



func _process(delta: float) -> void:
	super._process(delta)
	if target:
		$rotator.look_at(target.global_position)
		$rotator.rotation.x = 0
		$rotator.rotation.z = 0
