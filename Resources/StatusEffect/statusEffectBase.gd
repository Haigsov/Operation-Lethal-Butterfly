class_name StatusEffectBase;

@export var name : String = "Unnamed Status Effect";
@export var description: String = "No Description";
@export var iconResourcePath = "";

@export var count : int;

var target : Unit;
var applier : Unit;


signal on_activated(unit : Unit)
signal on_expire;


func _init(target : Unit, applier : Unit, count : int) -> void:
	self.target = target;
	self.applier = target;
	
@warning_ignore("unused_parameter")
func disable():
	pass


func decrease_count():
	count-=1;
	if (count <= 0):
		on_expire.emit();
