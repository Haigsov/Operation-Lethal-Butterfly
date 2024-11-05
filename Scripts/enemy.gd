extends Unit

const textWriter  = preload("res://Scripts/textWriter.gd");
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready();
	gridMovementModule.is_click_to_move_enabled = false;
	initiativeModule.on_turn_start.connect(superdumbai);
	initiativeModule.initiativeName = "GenericEnemy"

func superdumbai():
	textWriter.spawn_toast(get_tree().root, global_position + Vector2(0, -32), "It's my turn!", Color.RED);
	await get_tree().create_timer(1.5).timeout
	textWriter.spawn_toast(get_tree().root, global_position + Vector2(0, -32), "But I dont have an AI yet...", Color.RED);
	await get_tree().create_timer(1.5).timeout
	textWriter.spawn_toast(get_tree().root, global_position + Vector2(0, -32), "So I'm just gonna end my turn now.", Color.RED);
	await get_tree().create_timer(1.5).timeout
	initiativeModule.end_turn();

# Check if there is a player in the range to fight - Iyana
func _on_area_2d_area_entered(area: Area2D) -> void:
	print("Time to fight the player!!")


func _on_area_2d_area_exited(area: Area2D) -> void:
	print("There's no one to fight....")
