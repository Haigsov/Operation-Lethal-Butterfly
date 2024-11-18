extends StatusEffectBase

class_name StatusBleed

# Called when the node enters the scene tree for the first time.
func _init(target : Unit, applier : Unit, count : int) -> void:
	super(target, applier, count);
	name = "Bleed";
	description = "On turn end, take X damage and reduce count by 1"
	
	target.initiativeModule.on_turn_end.connect(dealBleedDamage);
	
func disable()->void:
	target.initiativeModule.on_turn_end.disconnect(dealBleedDamage);

func dealBleedDamage()->void:
	#applier.damage(target);
	decrease_count();
	pass
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
