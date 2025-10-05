extends Tower
class_name Magnet

func _ready() -> void:
	$Selector/CollisionShape3D.disabled = true
	super._ready()

func place():
	super.place()
	$Selector/CollisionShape3D.disabled = false

func _process(delta: float) -> void:
	super._process(delta)

func shoot():
	if(not can_fire or not is_placed):
		return
	for i: Pickable  in get_tree().get_nodes_in_group("pickable"):
		if i.global_position.distance_to(global_position) <= fire_range:
			i.collect(false)
	can_fire = false
	$Timer.start(cooldown)

func _on_selector_mouse_entered() -> void:
	hovered = true

func _on_selector_mouse_exited() -> void:
	hovered = false

func sell(percent):
	game.amount_wood += game.METAL_COST_PRIMARY * percent
	
	match secondary:
		Globals.ETypes.WOOD:
			game.amount_wood += game.WOOD_COST_SECONDARY * percent
		Globals.ETypes.FIRE:
			game.amount_fire += game.FIRE_COST_SECONDARY * percent
		Globals.ETypes.METAL:
			game.amount_metal += game.METAL_COST_SECONDARY * percent
		Globals.ETypes.PLAGUE:
			game.amount_plague += game.PLAGUE_COST_SECONDARY * percent
		Globals.ETypes.CANDY:
			game.amount_candy += game.CANDY_COST_SECONDARY * percent
	
	if(game.selected_tower == self):
		game.selected_tower = null
	
	queue_free()

func _on_timer_timeout() -> void:
	can_fire = true
