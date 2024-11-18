extends Node2D

class_name MenuBase

#current plan:
#Menus should be functions that are stalled with await.
#A menu should, when opened:
#	-Spawn their respective PackedScene
#	-Bind all relevant buttons to relevant functions
#	-await for user input
#	-Close themselves.
#because of this, menus are *not* pooled
#menu scenes also have *no attached scripts*; all the binding happens when the object is created.


#This class is not necessary since GDScript is not a real OOP language -Jody

var parent : Node2D;

func _init(parent : Node2D)->void:
	pass

func open()->void:
	pass;
