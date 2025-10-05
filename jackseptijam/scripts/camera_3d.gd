extends Camera3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	top_level = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#global_position =get_parent().global_position+Vector3(0,5.631, 2.32)
	global_position = lerp(global_position, get_parent().global_position+Vector3(0,5.631, 2.32), 0.06)
