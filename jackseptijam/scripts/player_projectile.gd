extends Node3D

@export var damage = 20.0
@export var speed = 25.0


func setup():
	var dir = (global_position-StoatStash.get_mouse_world_position_3d_collision(get_node("../CharacterBody3D/Camera3D"))).normalized()
	rotation.y = atan2(dir.z, dir.x)


func _process(delta: float) -> void:
	var dir = -StoatStash.vector_from_angle(rotation.y, speed*delta)
	position += Vector3(dir.x, 0, dir.y)
	
	for i: Enemy in get_tree().get_nodes_in_group("enemy"):
		if i.global_position.distance_to(global_position) < 1.8:
			
			hit_target(i)

func hit_target(target_enemy: Enemy):
	if target_enemy and target_enemy.has_method("take_damage"):
		target_enemy.take_damage(damage)
	
	queue_free()
