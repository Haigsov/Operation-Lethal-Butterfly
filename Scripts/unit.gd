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
	
	for t : TraitBase in traits:
		t.enable(self);
		
	#print(stats.toString());	
	initiativeModule.on_turn_start.connect(func(): movement_allowance = 5);

	initiativeModule.initiativeName = "GenericUnit"


#moves a unit, returns 
func move(destination : Vector2i) -> bool:
	var new_movement_allowance = gridMovementModule.move_limited(destination, movement_allowance);
	if (new_movement_allowance != -1): #valid movement
		movement_allowance = new_movement_allowance;
	else:
		return false;
	return true;
	

func _exit_tree():
	for t in traits:
		t.disable(self);

func end_turn():
	if (InitiativeTracker.instance.get_current_turn() == initiativeModule):
		InitiativeTracker.instance.next_turn();


func get_cell_position() -> Vector2i :
	return gridMovementModule.get_current_grid_location();
func get_distance_to(cell : Vector2i) :
	return gridMovementModule.get_current_grid_location().distance_to(cell);
