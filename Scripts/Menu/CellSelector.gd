extends Node2D

class_name CellSelector

var tilemap : TileMapLayer;
var criteria : Callable;

var doArrows : bool;
var arrowOrigin : Vector2i;
var line : Line2D;
var lastHovered : Vector2i;

signal cell_selected(Vector2i)

func _init(parent : Node, criteria : Callable):
	tilemap = parent.get_tree().current_scene.get_node("TileMap");
	self.tilemap = tilemap;
	self.criteria = criteria;
	parent.add_child(self);
	
func drawArrows(doArrows : bool, arrowOrigin : Vector2i = Vector2i.ZERO, width : int = 1, color : Color = Color.RED):
	self.doArrows = doArrows;
	self.arrowOrigin = arrowOrigin;
	if doArrows:
		line = Line2D.new();
		line.width = width;
		line.default_color = color;
		tilemap.add_child(line);
	else:
		line.queue_free()
		line = null;

	
func _process(delta: float) -> void:
	if (!doArrows):
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
	if (line !=null && !line.is_queued_for_deletion()):
		line.queue_free();	

func _unhandled_input(event: InputEvent) -> void:
	if (!event.is_action_pressed("move")): 
		return
	var clickedCell : Vector2i = tilemap.local_to_map(tilemap.get_local_mouse_position());
	if (criteria.call(clickedCell)):
		cell_selected.emit(clickedCell);
		queue_free();
