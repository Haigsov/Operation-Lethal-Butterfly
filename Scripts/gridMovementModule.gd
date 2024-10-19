extends Node

#A script to be attached to a child of any node that is supposed to be able to move
#along a grid.

class_name GridMovementModule

@onready var tile_map : TileMapLayer;

@onready var node = $".."
# AStarGrid2D is a grid used for pathfinding over the tile map, storing coordinates of tiles.
var astar_grid: AStarGrid2D
var current_id_path: Array[Vector2i]
var target_position: Vector2
var is_moving: bool

var is_click_to_move_enabled: bool = true

#non-walkable tiles; other than the ones from the map (usually unit positions)
var _non_walkable_cells : Array[Vector2i] = []; 

signal on_move; #emitted when movement begins;
signal on_stop; #emitted when movement stops;
signal on_step; #emitted every time the character reaches a tile;

func _ready() -> void:
	
	tile_map = get_tree().current_scene.get_node("TileMap")
	
	astar_grid = AStarGrid2D.new()
	# Set the region of astar_grid to match the used area of the tile_map
	astar_grid.region = tile_map.get_used_rect()
	# Set the cell size to 16x16 (adjustable depending on tile size)
	
	# from my testing .cell_size() doesnt change anything; possibly remove 
	#	-Jody
	astar_grid.cell_size = Vector2(16, 16)
	# Disable diagonal movement in the astar_grid
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	
	astar_grid.update()
	
	# Mark unwalkable tiles in astar_grid
	for x in tile_map.get_used_rect().size.x:
		for y in tile_map.get_used_rect().size.y:
			var tile_position = Vector2i(
				x + tile_map.get_used_rect().position.x,
				y + tile_map.get_used_rect().position.y
			)
			var tile_data = tile_map.get_cell_tile_data(tile_position)
			
			if tile_data == null or tile_data.get_custom_data("walkable") == false:
				astar_grid.set_point_solid(tile_position)
	
	
#moved to _unhandled_input so that GUI can "block" inputs	
func _unhandled_input(event: InputEvent) -> void:
	# Check if the 'move' action is pressed
	if (!event.is_action_pressed("move")):
		return
	if (!is_click_to_move_enabled): #only if click_to_move is enabled
		return
	# Determine path based on whether the character is currently moving
	
	var id_path = astar_grid.get_id_path(
			tile_map.local_to_map(node.position if (!is_moving) else target_position),
			tile_map.local_to_map(tile_map.get_local_mouse_position())
		)
	
	# If a valid path is found, update the current path
	if id_path.is_empty() == false:
		current_id_path = id_path

#move to a cell, returns movementAllowance - number of spaces moved, or -1 if not a valid path
func move_limited(destinationCell : Vector2i, movementAllowance : int) -> int:
	var path = astar_grid.get_id_path(tile_map.local_to_map(node.position), destinationCell);
	if (path == null || path.size()-1 > movementAllowance):
		return -1;
	current_id_path = path;
	
	if (movementAllowance - (path.size()-1) < 0):
		return 0;
	return movementAllowance - (path.size()-1);

		
func _physics_process(_delta: float) -> void:
	# Exit if no path exists
	if current_id_path.is_empty():
		return
	
	# Set target position and start moving
	if is_moving == false:
		target_position = tile_map.map_to_local(current_id_path.front())
		is_moving = true
		on_move.emit();
		
	# Move towards target position
	node.position = node.position.move_toward(target_position, 1)
	
	# When reaching a point, move to the next or stop if path is done
	if node.position == target_position:
		
		on_step.emit();
		current_id_path.pop_front()
		
		if current_id_path.is_empty() == false:
			target_position = tile_map.map_to_local(current_id_path.front())
		else:
			is_moving = false
			on_stop.emit();
	

func get_current_grid_location() -> Vector2i:
	return tile_map.local_to_map(node.position);

#sets more cells as solid; used for 
func set_non_walkable_cells(arr : Array[Vector2i]):
	for cell in _non_walkable_cells:
		astar_grid.set_point_solid(cell, false);
	
	_non_walkable_cells.clear();
	
	for cell in arr:
		if (!astar_grid.is_point_solid(cell)):
			astar_grid.set_point_solid(cell);
			_non_walkable_cells.append(cell);			

func is_cell_walkable(v : Vector2i) -> bool:
	return  astar_grid.is_point_solid(v)
