extends Node

#A script to be attached to a child of any node that is supposed to be able to move
#along a grid.

class_name GridMovementModule

@onready var tile_map : TileMapLayer;

@onready var node = $".."
# AStarGrid2D is a grid used for pathfinding over the tile map, storing coordinates of tiles.
var current_id_path: Array[Vector2i]
var target_position: Vector2
var is_moving: bool

var is_click_to_move_enabled: bool = true

var last_position : Vector2i;

signal on_move; #emitted when movement begins;
signal on_stop; #emitted when movement stops;
signal on_step; #emitted every time the character reaches a tile;

func _ready() -> void:
	
	tile_map = get_tree().current_scene.get_node("TileMap")
	last_position = tile_map.local_to_map(node.position);
	_occupy_cell_locations();
	
#moved to _unhandled_input so that GUI can "block" inputs	
func _unhandled_input(event: InputEvent) -> void:
	# Check if the 'move' action is pressed
	if (!event.is_action_pressed("move")):
		return
	if (!is_click_to_move_enabled): #only if click_to_move is enabled
		return
	# Determine path based on whether the character is currently moving
	
	var id_path = PathingManager.instance.get_id_path(
			tile_map.local_to_map(node.position if (!is_moving) else target_position),
			tile_map.local_to_map(tile_map.get_local_mouse_position())
		)
	# If a valid path is found, update the current path
	if id_path.is_empty() == false:
		current_id_path = id_path

#move to a cell, returns movementAllowance - number of spaces moved, or -1 if not a valid path
func move_limited(destinationCell : Vector2i, movementAllowance : int) -> int:
	var path = PathingManager.instance.get_id_path(tile_map.local_to_map(node.position), destinationCell);
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
		
		var t = current_id_path.pop_front()
		on_step.emit();
		_occupy_cell_locations(); #occupies current location and next location, unoccupies previous location
		last_position = t;
		
		if !current_id_path.is_empty() && (last_position==get_current_grid_location() || !PathingManager.instance.is_cell_occupied(current_id_path.front())):
			target_position = tile_map.map_to_local(current_id_path.front())
		else:
			is_moving = false
			current_id_path.clear();
			on_stop.emit();
	

func get_current_grid_location() -> Vector2i:
	return tile_map.local_to_map(node.position);

func _occupy_cell_locations():
	if (is_moving):
		if (last_position != get_current_grid_location()):
			PathingManager.instance.unoccupy(last_position);
		if (current_id_path.size() > 0):
			PathingManager.instance.occupy(current_id_path.front());
	else:
		PathingManager.instance.occupy(get_current_grid_location());
