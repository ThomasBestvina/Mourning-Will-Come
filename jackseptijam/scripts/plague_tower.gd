extends Node3D

@export var cooldown = 3.0
@export var plague_duration = 3.0

var secondary = Globals.WOOD


func place():
	await StoatStash.repeat_call(fire, cooldown)
	$RangeDisplayMesh.hide()


func fire():
	for enemy: Enemy in get_tree().get_nodes_in_group("enemy"):
		enemy.modifier_stack.append(["plague", plague_duration])
