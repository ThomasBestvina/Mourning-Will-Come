extends Node3D

@export var player_health = 100

var current_difficulty: int = 1
var points: int = 2

var buying_tower = false
var bought_tower: Node3D = null
var primary
var secondary
var which_button_primary_update = false
var which_button_secondary_update = false

var selected_tower: Node3D

@export var ballista_tower: PackedScene
@export var plague_tower: PackedScene

var placed_first_turret: bool = false

var amount_wood = 0
var amount_plague = 0
var amount_fire = 0
var amount_metal = 0
var amount_candy = 0

const WOOD_COST_PRIMARY = 5
const PLAGUE_COST_PRIMARY = 2
const FIRE_COST_PRIMARY = 5
const METAL_COST_PRIMARY = 5
const CANDY_COST_PRIMARY = 5

const WOOD_COST_SECONDARY = 5
const PLAGUE_COST_SECONDARY = 5
const FIRE_COST_SECONDARY = 5
const METAL_COST_SECONDARY = 5
const CANDY_COST_SECONDARY = 9

const WOOD_COLOR = "[color=fcb103]"
const PLAGUE_COLOR = "[color=222e38]"
const FIRE_COLOR = "[color=ff1231]"
const METAL_COLOR = "[color=2e2e2e]"
const CANDY_COLOR = "[color=ff21ed]"

var enemies = {
	1: [preload("res://objects/enemies/rat_enemy.tscn")],
	3: [preload("res://objects/enemies/tree_enemy.tscn")]
}


func _process(delta: float) -> void:
	manage_player_input()
	process_ui()

func increase_difficulty():
	current_difficulty += 1

func increase_points():
	points += current_difficulty * 2.5

func spawn_wave():
	if StoatStash.chance(0.4):
		spawn_enemies()

func process_ui():
	$UI/Health.text = "Health: " + str(player_health)
	$UI/BuyMenu/WoodAmount.text = WOOD_COLOR+str(amount_wood)
	$UI/BuyMenu/PlagueAmount.text = PLAGUE_COLOR+ str(amount_plague)
	$UI/BuyMenu/MetalAmount.text = METAL_COLOR+ str(amount_metal)
	$UI/BuyMenu/FireAmount.text = FIRE_COLOR+ str(amount_fire)
	$UI/BuyMenu/CandyAmount.text = CANDY_COLOR+ str(amount_candy)
	
	match primary:
		Globals.ETypes.WOOD:
			$UI/BuyMenu/CostPrimary.text = WOOD_COLOR+str(WOOD_COST_PRIMARY)
		Globals.ETypes.PLAGUE:
			$UI/BuyMenu/CostPrimary.text = PLAGUE_COLOR+str(PLAGUE_COST_PRIMARY)
		Globals.ETypes.FIRE:
			$UI/BuyMenu/CostPrimary.text = FIRE_COLOR+str(FIRE_COST_PRIMARY)
		Globals.ETypes.METAL:
			$UI/BuyMenu/CostPrimary.text = METAL_COLOR+str(METAL_COST_PRIMARY)
		Globals.ETypes.CANDY:
			$UI/BuyMenu/CostPrimary.text = CANDY_COLOR+str(CANDY_COST_PRIMARY)
	match secondary:
		Globals.ETypes.WOOD:
			$UI/BuyMenu/CostSecondary.text = WOOD_COLOR+ str(WOOD_COST_PRIMARY)
		Globals.ETypes.PLAGUE:
			$UI/BuyMenu/CostSecondary.text = PLAGUE_COLOR+str(PLAGUE_COST_PRIMARY)
		Globals.ETypes.FIRE:
			$UI/BuyMenu/CostSecondary.text = FIRE_COLOR+str(FIRE_COST_PRIMARY)
		Globals.ETypes.METAL:
			$UI/BuyMenu/CostSecondary.text = METAL_COLOR+str(METAL_COST_PRIMARY)
		Globals.ETypes.CANDY:
			$UI/BuyMenu/CostSecondary.text = CANDY_COLOR+str(CANDY_COST_PRIMARY)
			

	$UI/BuyMenu/Slot1Background.frame = 0 if primary else 1
	$UI/BuyMenu/Slot2Background.frame = 0 if secondary else 1


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
		await get_tree().create_timer(0.9).timeout
		

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
	
	points = remaining_points
	return spawns

func manage_player_input():
	if buying_tower:
		bought_tower.position = StoatStash.get_mouse_world_position_3d_collision($CharacterBody3D/Camera3D)
		if Input.is_action_just_pressed("place_tower"):
			StoatStash.safe_signal_connect(bought_tower.selected, selected)
			StoatStash.safe_signal_connect(bought_tower.deselected, deslected)
			bought_tower.place()
			bought_tower = null
			buying_tower = false
			if(not placed_first_turret):
				StoatStash.repeat_call(increase_difficulty, 30.0)
				StoatStash.repeat_call(increase_points, 10.0)
				StoatStash.repeat_call(spawn_wave, 12.0)
				placed_first_turret = true

func selected(tower: Node3D):
	for i in $Towers.get_children():
		if(tower != i):
			i.is_selected = false
	selected_tower = tower

func deslected(tower: Node3D):
	if(selected_tower == tower):
		selected_tower == null

func _on_buy_button_pressed() -> void:
	if primary == null or secondary == null: return
	
	match primary:
		Globals.ETypes.WOOD:
			bought_tower = ballista_tower.instantiate()
			amount_wood -= amount_wood
		Globals.ETypes.PLAGUE:
			bought_tower = plague_tower.instantiate()
			amount_plague -= amount_plague
	
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
