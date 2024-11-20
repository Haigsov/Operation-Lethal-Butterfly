extends StatusEffectBase

class_name StatusCommandersMark

func _init(target : Unit, applier : Unit, count : int)->void:
	super(target, applier, count);
	name = "Commander's Mark"
	description = "Take X extra damage per hit, increasing by Y for each hit taken until this effect expires"
	
	
	self.applier = applier;
	
	
	applier.initiativeModule.on_turn_start.connect(decrease_count);
	#target.before_damage_taken.connect(modifyDamageTaken(AttackInfo));

func enable(unit : Unit):
	applier.initiativeModule.on_turn_start.connect(decrease_count);
	#target.before_damage_taken.connect(modifyDamageTaken(AttackInfo));
	

func modifyDamageTaken(AttackInfo):
	#do some editing to the attack info
	pass


func disable():
	applier.initiativeModule.on_turn_start.disconnect(decrease_count);
	#target.before_damage_taken.disconnect(modifyDamageTaken(AttackInfo));
	pass
