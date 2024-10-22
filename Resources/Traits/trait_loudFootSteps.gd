extends TraitBase

class_name Trait_Loud_FootSteps;

const textWriter  = preload("res://Scripts/textWriter.gd");

func spawnFootStepEffect(unit: Unit):
	on_activated.emit();
	textWriter.spawn_toast(unit.get_tree().root, unit.global_position, "*step*", Color.RED, 32, 10, 0.7);

func enable(unit:Unit):
	unit.gridMovementModule.on_step.connect(spawnFootStepEffect.bind(unit));
	
func disable(unit:Unit):
	unit.gridMovementModule.on_step.disconnect(spawnFootStepEffect);
