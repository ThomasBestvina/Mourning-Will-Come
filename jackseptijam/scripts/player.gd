extends CharacterBody3D
class_name Player

@export var shoot_cooldown = 1.5

const SPRINT_SPEED = 13.0
const SPEED = 9.5
const JUMP_VELOCITY = 4.5

var canshoot: bool = true

@onready var projectile = preload("res://objects/player_projectile.tscn")

func _process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		$playerDoctor/AnimationPlayer.current_animation = "2Walk"
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		var target_angle = atan2(direction.x, direction.z)
		$LowerBody.rotation.y = lerp_angle($LowerBody.rotation.y, target_angle, 0.05)
	else:
		$playerDoctor/AnimationPlayer.current_animation = "1HoldGun"
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	
	
	if Input.is_action_just_pressed("shoot") and canshoot and get_parent().amount_musket_balls > 0:
		StoatStash.shake_3d($Camera3D,0.03, 0.15)
		var pp: Node3D = projectile.instantiate()
		get_parent().add_child(pp)
		pp.global_position = $UpperBody/Aimer.global_position
		pp.setup()
		get_parent().amount_musket_balls -= 1
		canshoot = false
		$ShootTimer.start(shoot_cooldown)
	
	
	$UpperBody.look_at(StoatStash.get_mouse_world_position_3d_plane($Camera3D))
	$UpperBody.rotation.x = 0
	$UpperBody.rotation.z = 0

	move_and_slide()


func _on_shoot_timer_timeout() -> void:
	canshoot = true
