extends Node


@export var initiativeName : String
@export var initiativeBonus : int

signal on_initiative_roll
signal on_turn_start
signal on_turn_change



func getInitiativeInfo():
	return {"name": initiativeName, "bonus": initiativeBonus}

# Called when the node enters the scene tree for the first time.
func _ready():	
	add_to_group("initiative")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func NotifyInitiativeRoll():
	on_initiative_roll.emit()
	
func NotifyTurnStart():
	on_turn_start.emit()

func NotifyTurnChange():
	on_turn_change.emit()
