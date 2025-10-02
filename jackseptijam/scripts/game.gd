extends Node3D

enum {WOOD, PLAGUE, FIRE, METAL, CANDY}

var button_stack = []

var which_button_update = false

var buying_tower = false
var bought_tower: Node3D = null

@export var ballista: PackedScene
@export var plague_tower: PackedScene


func _process(delta: float) -> void:
	manage_ui()
	manage_player_input()

func manage_player_input():
	if buying_tower:
		

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
	if(button_stack != 2): return
	
	buying_tower = true
	

func button_toggle_handler(toggled_on: bool, type):
	if not toggled_on:
		button_stack.erase(type)
	else:
		button_stack.append(type)

func _on_wood_toggled(toggled_on: bool) -> void:
	button_toggle_handler(toggled_on, [WOOD, %GridContainer/Wood/Sprite.texture])

func _on_plague_toggled(toggled_on: bool) -> void:
	button_toggle_handler(toggled_on, [PLAGUE, %GridContainer/Plague/Sprite.texture])

func _on_fire_toggled(toggled_on: bool) -> void:
	button_toggle_handler(toggled_on, [FIRE, %GridContainer/Fire/Sprite.texture])

func _on_metal_toggled(toggled_on: bool) -> void:
	button_toggle_handler(toggled_on, [METAL, %GridContainer/Metal/Sprite.texture])

func _on_candy_toggled(toggled_on: bool) -> void:
	button_toggle_handler(toggled_on, [CANDY, %GridContainer/Candy/Sprite.texture])
