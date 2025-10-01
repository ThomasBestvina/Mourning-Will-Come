extends Tower


func _process(delta: float) -> void:
	super._process(delta)
	if target:
		$rotator.look_at(target.global_position)
