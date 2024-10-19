extends Node

#super super simple menu system; will scale awfully but I dont know how UI is done in godot.
#-Jody
@export var Units : Array[Unit];
@export var Player : Ally;

@onready var tile_map : TileMapLayer;

var awaitingMove : bool = false;

@onready var beginCombatBtn = $BeginCombat
@onready var moveBtn = $Move
@onready var endTurnBtn = $"End Turn"
@onready var endCombatBtn = $"End Combat"


signal _clicked_on_tile(Vector2i);

func _ready():
	tile_map = get_tree().current_scene.get_node("TileMap");
	
	moveBtn.disabled =  true;
	endCombatBtn.disabled = true;
	endTurnBtn.disabled = true;

func _unhandled_input(event: InputEvent) -> void:
	if (!event.is_action_pressed("move")):
		return
	
	_clicked_on_tile.emit(tile_map.local_to_map(tile_map.get_local_mouse_position()))	

	


func _on_begin_combat_pressed() -> void:
	Player.gridMovementModule.is_click_to_move_enabled = false;
	Units[0].initiativeModule.start_combat(Units);
	
	beginCombatBtn.disabled = true;
	moveBtn.disabled = false;
	endTurnBtn.disabled = false;
	endCombatBtn.disabled = false;

func _on_move_pressed() -> void:
	if Player.movement_allowance <= 0:
		print("You cant move anymore!")
		return;
	print("Click to move. You can move %d more spaces!" % Player.movement_allowance);
	awaitingMove = true;
	var dest = await _clicked_on_tile;
	Player.move(dest);
	await Player.gridMovementModule.on_stop;
	print("You can still move %d more spaces!" % Player.movement_allowance);
	
func _on_end_turn_pressed() -> void:
	Player.initiativeModule.end_turn();
	
func _on_end_combat_pressed() -> void:
	Player.gridMovementModule.is_click_to_move_enabled = true;
	
	beginCombatBtn.disabled = false;
	moveBtn.disabled = true;
	endTurnBtn.disabled = true;
	endCombatBtn.disabled = true;
	
	InitiativeTracker.instance.end_combat()
