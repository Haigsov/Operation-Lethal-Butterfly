extends Node2D

#singleton pathing manager, allows stuff to path.
class_name PathingManager


static var instance : PathingManager;

var _astargrid : AStarGrid2D;
var _tilemap : TileMapLayer;


func _ready() -> void:
	instance = self;
	
	_tilemap = get_tree().current_scene.get_node("TileMap");
	
	_astargrid = AStarGrid2D.new();
	_astargrid.region = _tilemap.get_used_rect();
	_astargrid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	_astargrid.update()
	
	# Mark unwalkable tiles in astar_grid
	for x in _tilemap.get_used_rect().size.x:
		for y in _tilemap.get_used_rect().size.y:
			var tile_position = Vector2i(
				x + _tilemap.get_used_rect().position.x,
				y + _tilemap.get_used_rect().position.y
			)
			var tile_data = _tilemap.get_cell_tile_data(tile_position)
			
			if tile_data == null or tile_data.get_custom_data("walkable") == false:
				_astargrid.set_point_solid(tile_position)

func occupy(cell : Vector2i):
	_astargrid.set_point_solid(cell, true);
func unoccupy(cell : Vector2i):
	var tile_data = _tilemap.get_cell_tile_data(cell);
	if (tile_data == null || tile_data.get_custom_data("walkable") == true):
		_astargrid.set_point_solid(cell, false);


func get_id_path(start : Vector2i, end : Vector2i) -> Array[Vector2i]:
	return _astargrid.get_id_path(start, end);

func is_cell_occupied(cell : Vector2i) -> bool:
	return _astargrid.is_point_solid(cell);
