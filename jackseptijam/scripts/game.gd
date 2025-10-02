extends Node3D

var button_stack = []

var which_button_update = false

var buying_tower = false
var bought_tower: Node3D = null

@export var ballista_tower: PackedScene
@export var plague_tower: PackedScene


func _process(delta: float) -> void:
	manage_ui()
	manage_player_input()

func manage_player_input():
	if buying_tower:
		bought_tower.position = StoatStash.get_mouse_world_position_3d_collision($CharacterBody3D/Camera3D)
		if Input.is_action_just_pressed("place_tower"):
			bought_tower = null
			buying_tower = false

func manage_ui():
	if len(button_stack) == 2 and not which_button_update:
		for button in %GridContainer.get_children():
			if button is TextureButton and not button.button_pressed:
				button.disabled = true
		which_button_update = true
	elif len(button_stack) < 2 and which_button_update:
		for button in %GridContainer.get_children():
			if button is TextureButton:
				button.disabled = false
		which_button_update = false
	
	if(button_stack.size() > 0):
		$UI/BuyMenu/Slot1.texture = button_stack[0][1]
	else:
		$UI/BuyMenu/Slot1.texture = null
	if(button_stack.size() > 1):
		$UI/BuyMenu/Slot2.texture = button_stack[1][1]
	else:
		$UI/BuyMenu/Slot2.texture = null

func _on_buy_button_pressed() -> void:
	if(len(button_stack) != 2): return
	
	match button_stack[0][0]:
		Globals.WOOD:
			bought_tower = ballista_tower.instantiate()
		Globals.PLAGUE:
			bought_tower = plague_tower.instantiate()
	
	bought_tower.secondary = button_stack[1][0]
	add_child(bought_tower)
	buying_tower = true
	
	

func button_toggle_handler(toggled_on: bool, type):
	if not toggled_on:
		button_stack.erase(type)
	else:
		button_stack.append(type)

func _on_wood_toggled(toggled_on: bool) -> void:
	button_toggle_handler(toggled_on, [Globals.WOOD, %GridContainer/Wood/Sprite.texture])

func _on_plague_toggled(toggled_on: bool) -> void:
	button_toggle_handler(toggled_on, [Globals.PLAGUE, %GridContainer/Plague/Sprite.texture])

func _on_fire_toggled(toggled_on: bool) -> void:
	button_toggle_handler(toggled_on, [Globals.FIRE, %GridContainer/Fire/Sprite.texture])

func _on_metal_toggled(toggled_on: bool) -> void:
	button_toggle_handler(toggled_on, [Globals.METAL, %GridContainer/Metal/Sprite.texture])

func _on_candy_toggled(toggled_on: bool) -> void:
	button_toggle_handler(toggled_on, [Globals.CANDY, %GridContainer/Candy/Sprite.texture])
