extends Node

class_name InitiativeClient;

@export var initiativeName : String
@export var initiativeBonus : int

signal on_initiative_roll
signal on_turn_start(parent)
signal on_turn_change
signal on_turn_end

func getInitiativeInfo():
	return {"name": initiativeName, "bonus": initiativeBonus}

func start_combat(units : Array[Unit]):
	var clients : Array[InitiativeClient];
	for unit in units:
		clients.append(unit.initiativeModule);
	InitiativeTracker.instance.start_combat(clients);

func NotifyInitiativeRoll():
	on_initiative_roll.emit()
	
func NotifyTurnStart():
	on_turn_start.emit(get_parent())
	print(get_parent())

func NotifyTurnChange():
	on_turn_change.emit()
	
func end_turn():
	InitiativeTracker.instance.next_turn();
