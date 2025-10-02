extends Node3D

var primary
var secondary

var which_button_primary_update = false
var which_button_secondary_update = false

var buying_tower = false
var bought_tower: Node3D = null

@export var ballista_tower: PackedScene
@export var plague_tower: PackedScene

func _process(delta: float) -> void:
	manage_player_input()

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
		Globals.WOOD:
			bought_tower = ballista_tower.instantiate()
		Globals.PLAGUE:
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
	button_toggle_primary_handler(Globals.WOOD, %FirstSlotButtons/Wood/Sprite.texture)

func _on_plague_pressed() -> void:
	button_toggle_primary_handler(Globals.PLAGUE, %FirstSlotButtons/Plague/Sprite.texture)

func _on_fire_pressed() -> void:
	button_toggle_primary_handler(Globals.FIRE, %FirstSlotButtons/Fire/Sprite.texture)

func _on_metal_pressed() -> void:
	button_toggle_primary_handler(Globals.METAL, %FirstSlotButtons/Metal/Sprite.texture)

func _on_candy_pressed() -> void:
	button_toggle_primary_handler(Globals.CANDY, %FirstSlotButtons/Candy/Sprite.texture)

func _on_wood_pressed2() -> void:
	button_toggle_secondary_handler(Globals.WOOD, %SecondSlotButtons/Wood/Sprite.texture)

func _on_plague_pressed2() -> void:
	button_toggle_secondary_handler(Globals.PLAGUE, %SecondSlotButtons/Plague/Sprite.texture)

func _on_fire_pressed2() -> void:
	button_toggle_secondary_handler(Globals.FIRE, %SecondSlotButtons/Fire/Sprite.texture)

func _on_metal_pressed2() -> void:
	button_toggle_secondary_handler(Globals.METAL, %SecondSlotButtons/Metal/Sprite.texture)

func _on_candy_pressed3() -> void:
	button_toggle_secondary_handler(Globals.CANDY, %SecondSlotButtons/Candy/Sprite.texture)
