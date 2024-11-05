extends Unit

class_name Ally;

const textWriter  = preload("res://Scripts/textWriter.gd");
#an ally is a unit that can be clicked on and commanded.
	
func _ready():
	super._ready();
	initiativeModule.initiativeName = "GenericAlly"
	initiativeModule.on_turn_start.connect(func() : textWriter.spawn_toast(get_tree().root, global_position + Vector2(0, -32), "It's my turn!", Color.RED));
	

# Check if there is an enemy in the range to fight - Iyana
func _on_area_2d_area_entered(area: Area2D) -> void:
	print("I can fight enemies!!")


func _on_area_2d_area_exited(area: Area2D) -> void:
	print("No enemies to fight")
