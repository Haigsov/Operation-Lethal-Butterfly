extends Control

#Script for a single Squadmate on the left squad bar.


@export var hp : int:
	set(value) : 
		if (hp != value):
			_hasHPChanged = true;
			hp = value;
@export var maxHP : int:
	set (value) :
		if (maxHP != value):
			maxHP = value;
			_hasHPChanged = true;
@export var ap : int :
	set(value):
		if (ap != value):
			ap = value;
			_hasAPChanged = true;
@export var maxAP: int :
	set(value):
		if (maxAP != value):
			maxAP = value;
			_hasAPChanged = true;		
@export var apFlashAmt : int :
	set(value):
		if (apFlashAmt != min(ap,value)):
			apFlashAmt = min(ap,value);
			doAPFlash();

var _hasHPChanged : bool;
var _hasAPChanged : bool;

const HEALTH_BAR_COLORS : Array = [Color.TRANSPARENT, Color.WHITE, Color.SKY_BLUE, Color.ORANGE, Color.PURPLE]
const APDefaultColor :Color = Color("00FFEC");
const APFlashColor : Color = Color.PURPLE;

var healthBarPips : Array;
var healthBarEmptyPips : Array;
var apBarPips: Array;
var apBarEmptyPips : Array;

var _flashTweeners: Array;


func _ready() -> void:
	for i : int in range(1,11):
		healthBarPips.append(get_node("HealthBar/Full/Pip%d" % i))
		healthBarEmptyPips.append(get_node("HealthBar/Empty/Pip%d" % i))
	for i : int in range(1,8):
		apBarPips.append(get_node("APBar/Full/Seg%d/Lower" % (i)))
		apBarPips.append(get_node("APBar/Full/Seg%d/Upper" % (i)))
		
		apBarEmptyPips.append(get_node("APBar/Empty/Seg%d/Lower" % (i)))
		apBarEmptyPips.append(get_node("APBar/Empty/Seg%d/Upper" % (i)))
	
	updateHealthBar();
	updateAPBar();
	

func setAlly(a : Ally):
	var portrait : TextureRect = ($PortraitFrame/PortraitClipMask/Portrait);
	#portrait.texture = #some way to get the portrait texture of the unit
	hp = a.stats.current_health;
	updateHealthBar();
	updateAPBar();

func _process(delta: float) -> void:
	if (_hasHPChanged):
		updateHealthBar();
	if (_hasAPChanged):
		updateAPBar();
		

func updateHealthBar():	
	var emptyBarsToDraw: int = min(maxHP,10);
	
	for pip : CanvasItem in healthBarEmptyPips:
		pip.modulate = Color.TRANSPARENT if emptyBarsToDraw < 1 else Color.WHITE;
			
		emptyBarsToDraw-=1;
		
			
	var colorIndex = floori(hp / 10) + 1;
	var hp_to_color = hp % 10;
	for pip : CanvasItem in healthBarPips:
		if (hp_to_color > 0):
			pip.modulate = HEALTH_BAR_COLORS[colorIndex];
			hp_to_color -=1
		else:
			pip.modulate = HEALTH_BAR_COLORS[colorIndex-1];
	_hasHPChanged = false;
func updateAPBar():
	
	var emptyBarsToDraw: int = min(maxAP,14);
	
	for pip : CanvasItem in apBarEmptyPips:
		pip.modulate = Color.TRANSPARENT if emptyBarsToDraw < 1 else APDefaultColor;
			
		emptyBarsToDraw-=1;
	
	var coloredCount = 0;
	for pip : CanvasItem in apBarPips:
		pip.modulate = APDefaultColor if coloredCount < ap else Color.TRANSPARENT;
		coloredCount += 1;
	
	_hasAPChanged = false;

func doAPFlash():
	if (apFlashAmt != _flashTweeners.size()):
		for tween: Tween in _flashTweeners:
			tween.kill();
		_flashTweeners.clear();
		_hasAPChanged = true;
		
	if (apFlashAmt > 0):
		for i : int in range(ap-apFlashAmt,ap):
			var tween : Tween = create_tween().set_loops();
			tween.tween_property(apBarPips[i],"modulate",APFlashColor, 1);
			tween.tween_property(apBarPips[i],"modulate",APDefaultColor, 1);
			_flashTweeners.append(tween);
