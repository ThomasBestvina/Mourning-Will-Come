extends Path3D
class_name Projectile


@export var speed: float = 10.0
@export var damage: float = 1.0

var target_enemy: Enemy
var path_follow: PathFollow3D
var has_hit: bool = false

var max_value = 0.0

var effect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	path_follow = $PathFollow3D

func setup_projectile(start_pos: Vector3, enemy: Node3D):
	"I'm alive!"
	target_enemy = enemy
	has_hit = false
	
	var mycurve = Curve3D.new()
	mycurve.add_point(start_pos)
	mycurve.add_point(enemy.global_position)
	self.curve = mycurve
	
	global_position = Vector3.ZERO

func _process(delta: float) -> void:
	if not target_enemy:
		queue_free()
		return
	
	if not target_enemy.is_inside_tree():
		queue_free()
		return
	
	curve.set_point_position(1, target_enemy.global_position)
	
	path_follow.progress += speed * delta
	
	if path_follow.progress_ratio < max_value:
		on_hit_target()
	else:
		max_value = path_follow.progress_ratio

func on_hit_target():
	if has_hit:
		return
	
	has_hit = true
	
	if target_enemy and target_enemy.has_method("take_damage"):
		target_enemy.take_damage(damage)
	
	if effect == Globals.ETypes.PLAGUE:
		target_enemy.modifier_stack.append([Globals.ETypes.PLAGUE, 3.0])
	
	queue_free()
