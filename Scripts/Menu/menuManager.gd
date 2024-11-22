extends Control


class_name MenuManager;

static var instance : MenuManager;

var hotbar : Control;
var activeSquadmate : Control;
var squadDisplays : Array;
var squadRefs : Array;


func _process(delta: float) -> void: #menus follow the camera
	updateSquadDisplays()

func _ready() -> void:
	instance = self;
	hotbar = get_node("Hotbar");
	activeSquadmate = get_node("ActiveSquadmate");
	squadDisplays = [get_node("Squad/AllyDisplay1"),get_node("Squad/AllyDisplay2"),get_node("Squad/AllyDisplay3"),get_node("Squad/AllyDisplay4")]
	

func displayCombatMenu(allies : Array):
	squadRefs = allies;
	for i : int in range(0,squadRefs.size()):
		squadDisplays[i].setAlly(squadRefs[i]);
		if (squadRefs[i].isActive):
			activeSquadmate.setAlly(squadRefs[i]);
		
func updateSquadDisplays():
	for i : int in range(0,squadRefs.size()):
		squadDisplays[i].hp = squadRefs[i].stats.current_hp;
		squadDisplays[i].active = squadRefs[i].isActive;
		if (squadRefs[i].isActive):
			activeSquadmate.setAlly(squadRefs[i]);
	


func _on_traits_btn_pressed() -> void:
	print("Test")
