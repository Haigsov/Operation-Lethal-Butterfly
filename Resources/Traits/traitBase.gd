extends Resource;

class_name TraitBase;

@export var name : String = "Unnamed Trait";
@export var description: String = "No Description";

signal on_activated(unit : Unit)

@warning_ignore("unused_parameter")
func enable(unit : Unit):
	pass


@warning_ignore("unused_parameter")
func disable(unit : Unit):
	pass
