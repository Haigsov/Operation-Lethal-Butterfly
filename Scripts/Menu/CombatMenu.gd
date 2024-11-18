class_name CombatMenu;

static var packedscene = preload("res://Scenes/Menu/CombatMenu.tscn");
var control : Control;
var parent : Node;
var ally : Ally;

var _move_btn : Button;
var _shoot_btn : Button;
var _melee_btn : Button;
var _trait_btn : Button;
var _wait_btn : Button;

signal _close;

func _init(parent : Node, ally : Ally)->void:
	control = packedscene.instantiate();
	self.parent = parent;
	self.ally = ally;
	
	_move_btn = control.find_child("Move");
	_shoot_btn = control.find_child("Shoot");
	_melee_btn = control.find_child("Melee");
	_trait_btn = control.find_child("Trait");
	_wait_btn = control.find_child("Wait");
	
func display_menu(position : Vector2 = Vector2.ZERO):
	control.position = position;
	parent.add_child(control);
	_update_btn_status();
	_opening_animation();
	_bindButtons();
	await _close;
	_closing_animation();
	control.queue_free();

func _update_btn_status():
	_move_btn.disabled = ally.movement_allowance <= 0
	
	
func _opening_animation():
	pass

func _closing_animation():
	pass
	
	
	
func _bindButtons():
	_move_btn.pressed.connect(_move);
	_wait_btn.pressed.connect(_wait);

func _move():
	_move_btn.disabled = true;
	print("Movement allowance: %s" % ally.movement_allowance);
	var cellSelector : CellSelector = CellSelector.new(parent.get_tree().root,
		func(v : Vector2i):
			return (PathingManager.instance.get_id_path(ally.get_cell_position(), v).size() - 1 <= ally.movement_allowance);
	);
	cellSelector.drawArrows(true, ally.get_cell_position());
	var dest : Vector2i = await cellSelector.cell_selected;
	ally.move(dest);
	await ally.gridMovementModule.on_stop;
	_move_btn.disabled = false;	
	_update_btn_status();
func _wait():
	_close.emit();
	ally.end_turn();

func setAllButtonDisabled(isDisabled : bool):
	_move_btn.disabled = isDisabled;
	_shoot_btn.disabled = isDisabled;
	_melee_btn.disabled = isDisabled;
	_trait_btn.disabled = isDisabled;
	_wait_btn.disabled = isDisabled;
