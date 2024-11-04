extends Node2D

class_name CellSelector

var tilemap : TileMapLayer;
var criteria : Callable;

var drawArrow : bool;
var arrowOrigin : Vector2i;
var line : Line2D;
var lastHovered : Vector2i;

signal cell_selected(Vector2i)

func _init(parent : Node, tilemap : TileMapLayer, criteria : Callable, drawArrow : bool, arrowOrigin : Vector2i = Vector2i.ZERO):
	self.tilemap = tilemap;
	self.criteria = criteria;
	self.drawArrow = drawArrow;
	self.arrowOrigin = arrowOrigin;
	
	if drawArrow:
		line = Line2D.new();
		line.width = 1;
		line.default_color = Color.RED;
		tilemap.add_child(line);
	
	parent.add_child(self);
	
func _process(delta: float) -> void:
	if (!drawArrow):
		return;
	var hover = tilemap.local_to_map(tilemap.get_local_mouse_position());
	if hover == lastHovered: 
		return;
	
	line.clear_points();
	var path = PathingManager.instance.get_id_path(arrowOrigin, hover);
	for cell in path:
		line.add_point(tilemap.map_to_local(cell));
	
	lastHovered = hover;
	
	
func _exit_tree() -> void:
	line.queue_free();	

func _unhandled_input(event: InputEvent) -> void:
	if (!event.is_action_pressed("move")): 
		return
	var clickedCell : Vector2i = tilemap.local_to_map(tilemap.get_local_mouse_position());
	if (criteria.call(clickedCell)):
		cell_selected.emit(clickedCell);
		queue_free();
