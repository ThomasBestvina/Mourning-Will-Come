extends Node3D

signal selected(obj: Node3D)
signal deselected(obj: Node3D)

@export var cooldown = 3.0
@export var plague_duration = 3.0

var secondary = Globals.ETypes.WOOD

var hovered: bool = false
var is_selected: bool = false
var is_placed: bool = false

func _ready() -> void:
	var lst = [$Cube, $Cube_001, $Cube_002]
	for i in lst:
		i.set_surface_override_material(0,i.get_active_material(0).duplicate())
		match secondary:
			Globals.ETypes.WOOD:
				i.get_surface_override_material(0).set_texture(0, preload("res://assets/3d/towers/placeHolderBallista_woodPallete.png"))
			Globals.ETypes.PLAGUE:
				i.get_surface_override_material(0).set_texture(0, preload("res://assets/3d/towers/placeHolderPlague_Plague.png"))

func _process(delta: float) -> void:
	if hovered and Input.is_action_just_pressed("place_tower"):
		emit_signal("selected", self)
		is_selected = true
	if not hovered and Input.is_action_just_pressed("place_tower"):
		emit_signal("deselected",self)
		is_selected = true
	$RangeDisplayMesh.visible = hovered or is_selected or not is_placed
	

func place():
	is_placed = true
	$RangeDisplayMesh.visible = false
	await StoatStash.repeat_call(fire, cooldown)


func fire():
	for enemy: Enemy in get_tree().get_nodes_in_group("enemy"):
		enemy.modifier_stack.append(["plague", plague_duration])


func _on_static_body_3d_mouse_entered() -> void:
	hovered = false


func _on_static_body_3d_mouse_exited() -> void:
	hovered = false
