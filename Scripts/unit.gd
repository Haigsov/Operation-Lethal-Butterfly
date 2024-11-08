extends Node2D;

class_name Unit;

#a unit is a class that has: 
#	-A sprite (this may later be abstracted into a sprite module whenever we 
#		start putting in animation logic, dunno how that works yet though
#	-A Grid Movement Module
#	-An Initiative Module
# 	-A Stats Resource
#	-An Array of Trait Resources

#all movement functionality has been abstracted into the GridMovementModule.gd script; 
#add a child of the player with GridMovementModule.gd attached to allow it to move.
# -Jody

@onready var gridMovementModule : GridMovementModule = $GridMovementModule;
@export var stats : Stats;
@export var traits : Array[TraitBase];
@onready var initiativeModule : InitiativeClient = $InitiativeClient;

var is_enemy : bool  = false;

var movement_allowance : int = 0;

func _ready() -> void:
	add_to_group("units");
	
	for t in traits:
		t.enable(self);
		
	_updatePathing();
	
	gridMovementModule.on_stop.connect(func(): _updatePathing());
	initiativeModule.on_turn_start.connect(func(): _updatePathing());
	#print(stats.toString());	
	initiativeModule.on_turn_start.connect(func(): movement_allowance = 5);

	initiativeModule.initiativeName = "GenericUnit"

func move(destination : Vector2i) -> void:
	var new_movement_allowance = gridMovementModule.move_limited(destination, movement_allowance);
	if (new_movement_allowance != -1): #valid movement
		movement_allowance = new_movement_allowance;
		
	
func _updatePathing():
	var arr : Array[Vector2i] = []; 
	for unit : Unit in get_tree().get_nodes_in_group("units"):
		arr.append(unit.gridMovementModule.get_current_grid_location());
	gridMovementModule.set_non_walkable_cells(arr);
	
func _exit_tree():
	for t in traits:
		t.disable(self);
