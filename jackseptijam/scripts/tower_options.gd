extends Control

@onready var game: Game = get_parent().get_parent()

var just_selected = false

var in_pos = Vector2(282, 534)
var out_pos = Vector2(282, 652)

var target_mode_order = [Tower.targetting_mode.STRONGEST, Tower.targetting_mode.NEAREST, Tower.targetting_mode.LAST, Tower.targetting_mode.FIRST]

var upgrade_amount_primary: int = 0
var upgrade_amount_secondary: int = 0
var upgrade_type_primary: Globals.ETypes
var upgrade_type_secondary: Globals.ETypes

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if game.selected_tower != null and game.selected_tower is Tower:
		$NextTargetMode.show()
		$Label.show()
		var tower: Tower = game.selected_tower
		match tower.target_mode:
			Tower.targetting_mode.STRONGEST:
				$Label.text = "STRONGEST"
			Tower.targetting_mode.NEAREST:
				$Label.text = "NEAREST"
			Tower.targetting_mode.LAST:
				$Label.text = "LAST"
			Tower.targetting_mode.FIRST:
				$Label.text = "FIRST"
	elif game.selected_tower != null:
		$NextTargetMode.hide()
		$Label.hide()
	
	if game.selected_tower != null and (game.selected_tower is Tower or game.selected_tower is Plague and not game.selected_tower is Magnet):
		$Upgrade.show()
		$UpgradeAmount.show()
		$UpgradeAmount.text = ""
		upgrade_amount_primary = 4*game.selected_tower.grade
		var should_disable = false
		if game.selected_tower is Balista:
			$UpgradeAmount.text += game.WOOD_COLOR+str(upgrade_amount_primary)+"+"
			upgrade_type_primary = Globals.ETypes.WOOD
			if(game.amount_wood < upgrade_amount_primary):
				should_disable = true
			if game.selected_tower.secondary == Globals.ETypes.WOOD and game.amount_wood < upgrade_amount_primary*2:
				should_disable = true
		if game.selected_tower is Plague:
			$UpgradeAmount.text += game.PLAGUE_COLOR+str(upgrade_amount_primary)+"+"
			upgrade_type_primary = Globals.ETypes.PLAGUE
			if(game.amount_plague < upgrade_amount_primary):
				should_disable = true
			if game.selected_tower.secondary == Globals.ETypes.PLAGUE and game.amount_plague < upgrade_amount_primary*2:
				should_disable = true
		if game.selected_tower is Sniper:
			$UpgradeAmount.text += game.METAL_COLOR+str(upgrade_amount_primary)+"+"
			upgrade_type_primary = Globals.ETypes.METAL
			if(game.amount_metal < upgrade_amount_primary):
				should_disable = true
			if game.selected_tower.secondary == Globals.ETypes.METAL and game.amount_metal < upgrade_amount_primary*2:
				should_disable = true
		if game.selected_tower is Cannon:
			$UpgradeAmount.text += game.FIRE_COLOR+str(upgrade_amount_primary)+"+"
			upgrade_type_primary = Globals.ETypes.FIRE
			if(game.amount_fire < upgrade_amount_primary):
				should_disable = true
			if game.selected_tower.secondary == Globals.ETypes.FIRE and game.amount_fire < upgrade_amount_primary*2:
				should_disable = true
		if game.selected_tower is CandyCannon:
			$UpgradeAmount.text += game.CANDY_COLOR+str(upgrade_amount_primary)+"+"
			upgrade_type_primary = Globals.ETypes.CANDY
			if(game.amount_candy < upgrade_amount_primary):
				should_disable = true
			if game.selected_tower.secondary == Globals.ETypes.CANDY and game.amount_candy < upgrade_amount_primary*2:
				should_disable = true
		match game.selected_tower.secondary:
			Globals.ETypes.WOOD:
				$UpgradeAmount.text += game.WOOD_COLOR+str(upgrade_amount_primary)
				if(game.amount_wood < upgrade_amount_primary):
					should_disable = true
			Globals.ETypes.PLAGUE:
				$UpgradeAmount.text += game.PLAGUE_COLOR+str(upgrade_amount_primary)
				if(game.amount_plague < upgrade_amount_primary):
					should_disable = true
			Globals.ETypes.METAL:
				$UpgradeAmount.text += game.METAL_COLOR+str(upgrade_amount_primary)
				if(game.amount_metal < upgrade_amount_primary):
					should_disable = true
			Globals.ETypes.FIRE:
				$UpgradeAmount.text += game.FIRE_COLOR+str(upgrade_amount_primary)
				if(game.amount_fire < upgrade_amount_primary):
					should_disable = true
			Globals.ETypes.CANDY:
				$UpgradeAmount.text += game.CANDY_COLOR+str(upgrade_amount_primary)
				if(game.amount_candy < upgrade_amount_primary):
					should_disable = true
		$Upgrade.disabled = should_disable
		
	
	if(game.selected_tower is Magnet):
		$Upgrade.hide()
		$UpgradeAmount.hide()
	
	if game.selected_tower != null and not just_selected:
		position = in_pos
		StoatStash.animate_ui_slide_in(self, Vector2.UP, out_pos)
		just_selected = true
	if game.selected_tower == null and just_selected:
		position = out_pos
		StoatStash.animate_ui_slide_in(self, Vector2.DOWN, in_pos)
		just_selected = false
	

func _on_button_pressed() -> void:
	if game.selected_tower != null and game.selected_tower is Tower:
		var tower: Tower = game.selected_tower
		tower.target_mode = target_mode_order[ (target_mode_order.find(tower.target_mode)+1) % 4 ]
		tower.choose_target()

func _on_sell_pressed() -> void:
	if game.selected_tower == null: return
	StoatStash.play_sfx(preload("res://assets/sound/sell_tower.wav"), 0.8)
	game.selected_tower.sell(0.5)


func _on_upgrade_pressed() -> void:
	match upgrade_type_primary:
		Globals.ETypes.WOOD:
			game.amount_wood -= upgrade_amount_primary
		Globals.ETypes.PLAGUE:
			game.amount_plague -= upgrade_amount_primary
		Globals.ETypes.METAL:
			game.amount_metal -= upgrade_amount_primary
		Globals.ETypes.FIRE:
			game.amount_fire -= upgrade_amount_primary
		Globals.ETypes.CANDY:
			game.amount_candy -= upgrade_amount_primary
	match game.selected_tower.secondary:
		Globals.ETypes.WOOD:
			game.amount_wood -= upgrade_amount_primary
		Globals.ETypes.PLAGUE:
			game.amount_plague -= upgrade_amount_primary
		Globals.ETypes.METAL:
			game.amount_metal -= upgrade_amount_primary
		Globals.ETypes.FIRE:
			game.amount_fire -= upgrade_amount_primary
		Globals.ETypes.CANDY:
			game.amount_candy -= upgrade_amount_primary
	
	game.selected_tower.upgrade()
	StoatStash.play_sfx(preload("res://assets/sound/upgrade_tower.wav"), 0.8)
