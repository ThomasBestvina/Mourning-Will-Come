extends Node3D

enum {WOOD, PLAGUE, FIRE}

var button_stack = []

var which_button_update = false

func _process(delta: float) -> void:
	if len(button_stack) == 2 and not which_button_update:
		for button in $UI/BuyMenu.get_children():
			if button is TextureButton and not button.button_pressed:
				button.disabled = true
		which_button_update = true
	elif len(button_stack) < 2 and which_button_update:
		for button in $UI/BuyMenu.get_children():
			if button is TextureButton:
				button.disabled = false
		which_button_update = false
	
	if(button_stack.get(0)):
		$UI/BuyMenu/Slot1.texture = button_stack[0][1]
	else:
		$UI/BuyMenu/Slot1.texture = null
	if(button_stack.get(1)):
		$UI/BuyMenu/Slot2.texture = button_stack[0][1]
	else:
		$UI/BuyMenu/Slot2.texture = null
	


func button_toggle_handler(toggled_on: bool, type):
	if not toggled_on:
		button_stack.erase(type)
	else:
		button_stack.append(type)

func _on_wood_toggled(toggled_on: bool) -> void:
	button_toggle_handler(toggled_on, [WOOD, $UI/BuyMenu/Wood.texture_normal])

func _on_plague_toggled(toggled_on: bool) -> void:
	button_toggle_handler(toggled_on, [PLAGUE, $UI/BuyMenu/Plague.texture_normal])

func _on_fire_toggled(toggled_on: bool) -> void:
	button_toggle_handler(toggled_on, [FIRE, $UI/BuyMenu/Fire.texture_normal])
