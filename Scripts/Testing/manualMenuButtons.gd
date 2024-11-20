extends Node

#super super simple menu system; will scale awfully but I dont know how UI is done in godot.
#-Jody
@export var Units : Array[Unit];
@export var Player : Ally;

@onready var tile_map : TileMapLayer;

var awaitingMove : bool = false;

@onready var beginCombatBtn = $BeginCombat
@onready var endCombatBtn = $"End Combat"


signal _clicked_on_tile(Vector2i);

func _ready():
	tile_map = get_tree().current_scene.get_node("TileMap");
	
	endCombatBtn.disabled = true;

func _unhandled_input(event: InputEvent) -> void:
	if (!event.is_action_pressed("move")):
		return
	
	_clicked_on_tile.emit(tile_map.local_to_map(tile_map.get_local_mouse_position()))	

	


func _on_begin_combat_pressed() -> void:
	Player.gridMovementModule.is_click_to_move_enabled = false;
	Units[0].initiativeModule.start_combat(Units);
	
	beginCombatBtn.disabled = true;
	endCombatBtn.disabled = false;

func _on_move_pressed() -> void:
	
	if Player.movement_allowance <= 0:
		print("You cant move anymore!")
		return;
		
	print("Click to move. You can move %d more spaces!" % Player.movement_allowance);
	
	var successfulMovement : bool = false;
	while !successfulMovement:
		
		var cellSelector : CellSelector = await CellSelector.new(get_tree().root,  
			(func(v : Vector2i) -> bool : return Player.get_distance_to(v) <= Player.movement_allowance));
		cellSelector.drawArrows(true, Player.get_cell_position());
		var dest : Vector2i = await cellSelector.cell_selected;
		successfulMovement = Player.move(dest);
		print(successfulMovement);
	await Player.gridMovementModule.on_stop;
	print("You can still move %d more spaces!" % Player.movement_allowance);
	
func _on_end_turn_pressed() -> void:
	Player.initiativeModule.end_turn();
	
func _on_end_combat_pressed() -> void:
	Player.gridMovementModule.is_click_to_move_enabled = true;
	
	beginCombatBtn.disabled = false;
	endCombatBtn.disabled = true;
	
	InitiativeTracker.instance.end_combat()
