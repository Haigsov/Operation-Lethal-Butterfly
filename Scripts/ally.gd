extends Unit

class_name Ally;

const textWriter  = preload("res://Scripts/textWriter.gd");
#an ally is a unit that can be clicked on and commanded.
	
func _ready():
	super._ready();
	initiativeModule.initiativeName = "GenericAlly"
	initiativeModule.on_turn_start.connect(func() : textWriter.spawn_toast(get_tree().root, global_position + Vector2(0, -32), "It's my turn!", Color.RED));
	
