
extends RefCounted
static var toastScene = load("res://Scenes/ToastNotification.tscn")

static func spawn_toast(parent: Node, global_position : Vector2, text : String, 
color : Color, r_offset_position : float = 0, r_offset_direction : float = 0, scale = 1):
	var toastNode : CenterContainer = toastScene.instantiate();
	toastNode.scale = Vector2(scale,scale);
	toastNode.color = color;
	toastNode.text = text;
	toastNode.global_position = global_position + Vector2(randf_range(-r_offset_position, r_offset_position), randf_range(-r_offset_position, r_offset_position));
	toastNode.movement_direction = Vector2(randf_range(-r_offset_direction, r_offset_direction), -1).normalized();
	parent.add_child(toastNode);
