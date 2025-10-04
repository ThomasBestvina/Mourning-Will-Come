extends RigidBody3D
class_name Pickable

var game: Game

@export var type: Globals.ETypes
@export var is_musket = false

func setup(typ, musket):
	type = typ
	is_musket = musket
	if is_musket:
		$Musket.show()
		return
	
	match type:
		Globals.ETypes.WOOD:
			$Wood.show()
		Globals.ETypes.PLAGUE:
			$Plague.show()
		Globals.ETypes.METAL:
			$Metal.show()
		Globals.ETypes.FIRE:
			$Fire.show()
		Globals.ETypes.CANDY:
			$Candy.show()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if not body is Player: return
	if is_musket:
		game.amount_musket_balls += 1
		kill()
		return
	
	match type:
		Globals.ETypes.WOOD:
			game.amount_wood += 1
		Globals.ETypes.PLAGUE:
			game.amount_plague += 1
		Globals.ETypes.METAL:
			game.amount_metal += 1
		Globals.ETypes.FIRE:
			game.amount_fire += 1
		Globals.ETypes.CANDY:
			game.amount_candy += 1
	kill()

func kill():
	StoatStash.play_sfx(preload("res://assets/sound/pickupCoin.wav"), 0.8, 0.8)
	queue_free()
