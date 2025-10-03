extends Control

@onready var game: Game = get_parent().get_parent()

var just_selected = false

var in_pos = Vector2(282, 585)
var out_pos = Vector2(282, 652)

var target_mode_order = [Tower.targetting_mode.STRONGEST, Tower.targetting_mode.NEAREST, Tower.targetting_mode.LAST, Tower.targetting_mode.FIRST]

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
	game.selected_tower.sell(0.5)
