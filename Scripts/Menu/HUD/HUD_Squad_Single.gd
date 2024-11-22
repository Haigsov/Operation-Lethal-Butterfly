extends Control

#Script for a single Squadmate on the left squad bar.


@export var hp : int #hp
var _delta_hp : int #previous hp; used to determine when to make changes

const BAR_COLORS : Array = [Color.TRANSPARENT, Color.WHITE, Color.SKY_BLUE, Color.ORANGE, Color.PURPLE]
var healthBarPips : Array;

var active : bool;
var _activeFrame : TextureRect;


func _ready() -> void:
	for i : int in range(1,11):
		healthBarPips.append(get_node("HealthBar/Pip%d" % i))
	_activeFrame = get_node("ActiveFrame");

func setAlly(a : Ally):
	var portrait : TextureRect = ($PortraitFrame/PortraitClipMask/Portrait);
	#portrait.texture = #some way to get the portrait texture of the unit
	hp = a.stats.current_health;
	_delta_hp = hp;
	updateHealthBar();

func _process(delta: float) -> void:
	if (hp != _delta_hp):
		updateHealthBar();
	_activeFrame.visible = active;
	

func updateHealthBar():	
	var colorIndex = floori(hp / 10) + 1;
	var hp_to_color = hp % 10;
	for pip : CanvasItem in healthBarPips:
		if (hp_to_color > 0):
			pip.modulate = BAR_COLORS[colorIndex];
			hp_to_color -=1
		else:
			pip.modulate = BAR_COLORS[colorIndex-1];
	_delta_hp = hp;
	
