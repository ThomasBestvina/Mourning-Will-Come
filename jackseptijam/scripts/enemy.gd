extends PathFollow3D
class_name Enemy

signal enemy_win(points)

signal died(type, amount)

@export_category("Properties")
@export var max_speed = 2.0
var speed = 2.0
@export var max_health = 10.0
var health = 10.0
@export var strength_score = 1.0

@export_category("Drops and Death")
@export var points: int = 1
@export var type: Globals.ETypes = Globals.ETypes.WOOD
@export var max_drops = 1
@export var drop_chance = 0.7

# modifiers are just arrays [mod_type, duration]
var modifier_stack = []

func _ready() -> void:
	health = max_health
	speed = max_speed

func _process(delta: float) -> void:
	set_progress(get_progress() + speed * delta)
	if health <= 0:
		var drops = 0
		for i in max_drops:
			if(StoatStash.chance(drop_chance)):
				drops += 1
		emit_signal("died", type, drops)
		queue_free()
	
	if(get_progress_ratio() >= 0.99):
		emit_signal("enemy_win", points)
		queue_free()
	

func _physics_process(delta: float) -> void:
	var plague = false
	for modifier in modifier_stack.duplicate():
		modifier[1] -= delta
		if(modifier[1] <= 0):
			modifier_stack.erase(modifier)
		match modifier[0]:
			"plague":
				if StoatStash.chance(0.05):
					take_damage(max_health/30)
				speed = max_speed - max_speed / 4
				plague = true
			"fire":
				if StoatStash.chance(0.1):
					take_damage(5)
	if not plague:
		speed = max_speed
	

func take_damage(damage: float):
	health -= damage
