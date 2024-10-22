extends TraitBase

class_name Trait_Healthy;

func _init():
	name = "Healthy";
	description = "+2 HP; +1 FORCEFUL"

func enable(unit : Unit):
	unit.stats.bonus_max_health += 1;
	unit.stats.bonus_forceful +=1;
