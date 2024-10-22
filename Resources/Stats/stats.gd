extends Resource
	
class_name Stats 

@export var current_health : int;
@export var armor : int = 0;
@export var war_dice : int = 0; 


@export var base_max_health : int = 6;
@export var base_forceful : int = 0;
@export var base_reflexive : int = 0;
@export var base_tactical : int = 0;
@export var base_willful : int = 0;


@export var bonus_max_health : int = 0;
@export var bonus_forceful : int = 0;
@export var bonus_reflexive : int = 0;
@export var bonus_tactical : int = 0;
@export var bonus_willful : int = 0;


func _init():
	current_health = base_max_health + bonus_max_health;

func toString():
	return """
	HEALTH    : %d/%d (%d + %d)
	FORCEUL   : %d (%d + %d)
	REFLEXIVE : %d (%d + %d)
	TACTICAL  : %d (%d + %d)
	WILLFUL   : %d (%d + %d)""" % [
		current_health, (base_max_health + bonus_max_health), base_max_health, bonus_max_health,
		(base_forceful + bonus_forceful), base_forceful, bonus_forceful,
		(base_reflexive + bonus_max_health), base_max_health, bonus_max_health,
		(base_tactical + bonus_tactical), base_tactical, bonus_tactical,
		(base_willful + bonus_willful), base_willful, bonus_willful,
		]
