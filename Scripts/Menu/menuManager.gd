extends Node2D


class_name MenuManager;

static var instance : MenuManager;

var Camera : Camera2D;

func _process(delta: float) -> void: #menus follow the camera
	#global_position = Camera.global_position;
	pass
func _ready() -> void:
	Camera = get_viewport().get_camera_2d();
	instance = self;

func displayCombatMenu(ally : Ally):
	var pos : Vector2 = Vector2(get_viewport_rect().size.x,0);
	await CombatMenu.new(self, ally).display_menu(pos);
	
