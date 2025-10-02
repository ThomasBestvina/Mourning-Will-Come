extends Node3D

@export var player_health = 100

var current_difficulty = 1
var points = 1

var buying_tower = false
var bought_tower: Node3D = null
var primary
var secondary
var which_button_primary_update = false
var which_button_secondary_update = false

@export var ballista_tower: PackedScene
@export var plague_tower: PackedScene

var amount_wood = 0
var amount_plague = 0
var amount_fire = 0
var amount_metal = 0
var amount_candy = 0

var enemies = {
	1: [preload("res://objects/enemies/rat_enemy.tscn")],
	3: [preload("res://objects/enemies/tree_enemy.tscn")]
}

func _process(delta: float) -> void:
	manage_player_input()
	process_ui()

func process_ui():
	$UI/Health.text = "Health: " + str(player_health)

func enemy_win(point):
	player_health -= point

func enemy_die(type, amount):
	match type:
		Globals.ETypes.WOOD:
			amount_wood += amount
		Globals.ETypes.FIRE:
			amount_fire += amount
		Globals.ETypes.PLAGUE:
			amount_plague += amount
		Globals.ETypes.CANDY:
			amount_candy += amount
		Globals.ETypes.METAL:
			amount_metal += amount

func spawn_enemies():
	var lst = get_spawns()
	for i: PackedScene in lst:
		var thing: Enemy = i.instantiate()
		$Path3D.add_child(thing)
		StoatStash.safe_signal_connect(thing.enemy_win, enemy_win)
		StoatStash.safe_signal_connect(thing.died, enemy_die)

# use points to spawn enemies of various values
func get_spawns():
	var spawns = []
	var remaining_points = points
	
	var costs = enemies.keys()
	costs.sort()
	
	var bomb_threshold = points / 2.0
	
	while remaining_points > 0:
		var affordable = []
		for cost in costs:
			if cost <= remaining_points:
				affordable.append(cost)
		
		if affordable.is_empty():
			break
		
		var selected_cost
		if affordable.back() >= bomb_threshold and randf() < 0.2:
			var expensive_options = affordable.filter(func(c): return c >= bomb_threshold )
			if not expensive_options.is_empty():
				selected_cost = expensive_options[randi() % expensive_options.size()]
			else:
				selected_cost = affordable.back()
		else:
			var weights = []
			var total_weight = 0.0
			for cost in affordable:
				var weight = 1.0 / float(cost)
				weights.append(weight)
				total_weight += weight
			
			var rand_val = randf() * total_weight
			var cumulative = 0.0
			selected_cost = affordable[0]
			
			for i in range(affordable.size()):
				cumulative += weights[i]
				if rand_val <= cumulative:
					selected_cost = affordable[i]
					break
		
		var enemy_options = enemies[selected_cost]
		spawns.append(enemy_options[randi() % enemy_options.size()])
		remaining_points -= selected_cost
	
	return spawns

func manage_player_input():
	if buying_tower:
		bought_tower.position = StoatStash.get_mouse_world_position_3d_collision($CharacterBody3D/Camera3D)
		if Input.is_action_just_pressed("place_tower"):
			bought_tower.place()
			bought_tower = null
			buying_tower = false

func _on_buy_button_pressed() -> void:
	if primary == null or secondary == null: return
	
	match primary:
		Globals.ETypes.WOOD:
			bought_tower = ballista_tower.instantiate()
		Globals.ETypes.PLAGUE:
			bought_tower = plague_tower.instantiate()
	
	bought_tower.secondary = secondary
	add_child(bought_tower)
	buying_tower = true

func button_toggle_primary_handler(type, texture):
	primary = type
	$UI/BuyMenu/Slot1.texture = texture

func button_toggle_secondary_handler(type, texture):
	secondary = type
	$UI/BuyMenu/Slot2.texture = texture

func _on_wood_pressed() -> void:
	button_toggle_primary_handler(Globals.ETypes.WOOD, %FirstSlotButtons/Wood/Sprite.texture)

func _on_plague_pressed() -> void:
	button_toggle_primary_handler(Globals.ETypes.PLAGUE, %FirstSlotButtons/Plague/Sprite.texture)

func _on_fire_pressed() -> void:
	button_toggle_primary_handler(Globals.ETypes.FIRE, %FirstSlotButtons/Fire/Sprite.texture)

func _on_metal_pressed() -> void:
	button_toggle_primary_handler(Globals.ETypes.METAL, %FirstSlotButtons/Metal/Sprite.texture)

func _on_candy_pressed() -> void:
	button_toggle_primary_handler(Globals.ETypes.CANDY, %FirstSlotButtons/Candy/Sprite.texture)

func _on_wood_pressed2() -> void:
	button_toggle_secondary_handler(Globals.ETypes.WOOD, %SecondSlotButtons/Wood/Sprite.texture)

func _on_plague_pressed2() -> void:
	button_toggle_secondary_handler(Globals.ETypes.PLAGUE, %SecondSlotButtons/Plague/Sprite.texture)

func _on_fire_pressed2() -> void:
	button_toggle_secondary_handler(Globals.ETypes.FIRE, %SecondSlotButtons/Fire/Sprite.texture)

func _on_metal_pressed2() -> void:
	button_toggle_secondary_handler(Globals.ETypes.METAL, %SecondSlotButtons/Metal/Sprite.texture)

func _on_candy_pressed3() -> void:
	button_toggle_secondary_handler(Globals.ETypes.CANDY, %SecondSlotButtons/Candy/Sprite.texture)
