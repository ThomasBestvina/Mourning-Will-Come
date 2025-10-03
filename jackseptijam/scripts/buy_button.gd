extends Button

@onready var game: Game = get_parent().get_parent().get_parent()

func _process(delta: float) -> void:
	if game.primary == null or game.secondary == null:
		disabled = true
	match game.primary:
		Globals.ETypes.WOOD:
			if(game.amount_wood < game.WOOD_COST_PRIMARY):
				disabled = true
				return
		Globals.ETypes.PLAGUE:
			if(game.amount_plague < game.PLAGUE_COST_PRIMARY):
				disabled = true
				return
		Globals.ETypes.FIRE:
			if(game.amount_fire < game.FIRE_COST_PRIMARY):
				disabled = true
				return
		Globals.ETypes.METAL:
			if(game.amount_metal < game.METAL_COST_PRIMARY):
				disabled = true
				return
		Globals.ETypes.CANDY:
			if(game.amount_candy < game.CANDY_COST_PRIMARY):
				disabled = true
				return
	match game.secondary:
		Globals.ETypes.WOOD:
			if(game.amount_wood < game.WOOD_COST_SECONDARY or (game.primary == Globals.ETypes.WOOD and game.amount_wood < game.WOOD_COST_PRIMARY + game.WOOD_COST_SECONDARY) ):
				disabled = true
				return
		Globals.ETypes.PLAGUE:
			if(game.amount_plague < game.PLAGUE_COST_SECONDARY or (game.primary == Globals.ETypes.PLAGUE and game.amount_plague < game.PLAGUE_COST_PRIMARY + game.PLAGUE_COST_SECONDARY)):
				disabled = true
				return
		Globals.ETypes.FIRE:
			if(game.amount_fire < game.FIRE_COST_SECONDARY or (game.primary == Globals.ETypes.FIRE and game.amount_fire < game.FIRE_COST_PRIMARY + game.FIRE_COST_SECONDARY)):
				disabled = true
				return
		Globals.ETypes.METAL:
			if(game.amount_metal < game.METAL_COST_SECONDARY or (game.primary == Globals.ETypes.METAL and game.amount_metal < game.METAL_COST_PRIMARY + game.METAL_COST_SECONDARY)):
				disabled = true
				return
		Globals.ETypes.CANDY:
			if(game.amount_candy < game.CANDY_COST_SECONDARY or (game.primary == Globals.ETypes.CANDY and game.amount_wood < game.CANDY_COST_PRIMARY + game.CANDY_COST_SECONDARY)):
				disabled = true
				return
	
	disabled = false
