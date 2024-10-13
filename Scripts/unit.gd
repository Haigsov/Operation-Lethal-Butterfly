extends Node2D;

class_name Unit;

#a unit is a class that has: 
#	-A sprite (this may later be abstracted into a sprite module whenever we 
		#start putting in animation logic, dunno how that works yet though
#	-A Grid Movement Module
#	-An Initiative Module
# 	-A Stats Resource
#	-An Array of Trait Resources

#all movement functionality has been abstracted into the GridMovementModule.gd script; 
#add a child of the player with GridMovementModule.gd attached to allow it to move.
# -Jody

@onready var gridMovementModule = $GridMovementModule;
@export var stats : Stats;
@export var traits : Array[TraitBase];
@onready var initiativeModule = $InitiativeClient;

#const textWriter  = preload("res://Scripts/textWriter.gd");


func _ready() -> void:
	
	for t in traits:
		t.enable(self);
	#gridMovementModule.on_move.connect(func() : textWriter.spawn_toast(get_tree().root, global_position + Vector2(0, -32), "Moving!", Color.RED));
	#gridMovementModule.on_stop.connect(func() : textWriter.spawn_toast(get_tree().root, global_position + Vector2(0, -32), "I've made it!", Color.RED));

	print(stats.toString());

func _input(_event: InputEvent) -> void:
	pass
	
	
func _exit_tree():
	for t in traits:
		t.disable(self);

	
	
