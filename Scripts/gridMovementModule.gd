extends Node

#A script to be attached to a child of any node that is supposed to be able to move
#along a grid.


@onready var tile_map = $"../../TileMap"

@onready var node = $".."
# AStarGrid2D is a grid used for pathfinding over the tile map, storing coordinates of tiles.
var astar_grid: AStarGrid2D
var current_id_path: Array[Vector2i]
var target_position: Vector2
var is_moving: bool
var movement_limit: int
var count: int

var is_click_to_move_enabled: bool

func _ready() -> void:
	astar_grid = AStarGrid2D.new()
	# Set the region of astar_grid to match the used area of the tile_map
	astar_grid.region = tile_map.get_used_rect()
	# Set the cell size to 16x16 (adjustable depending on tile size)
	
	# from my testing .cell_size() doesnt change anything; possibly remove 
	#	-Jody
	astar_grid.cell_size = Vector2(16, 16)
	# Disable diagonal movement in the astar_grid
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	# Doesn't have to be 3
	movement_limit = 3
	# Keeps track of how many moves player made
	count = 0
	
	is_click_to_move_enabled = true;
	
	astar_grid.update()
	
	# Mark unwalkable tiles in astar_grid
	for x in tile_map.get_used_rect().size.x:
		for y in tile_map.get_used_rect().size.y:
			var tile_position = Vector2i(
				x + tile_map.get_used_rect().position.x,
				y + tile_map.get_used_rect().position.y
			)
			var tile_data = tile_map.get_cell_tile_data(0, tile_position)
			
			if tile_data == null or tile_data.get_custom_data("walkable") == false:
				astar_grid.set_point_solid(tile_position)
	
	
func _input(event: InputEvent) -> void:
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
	
		#print(astar_grid.get_point_path(position, tile_map.get_local_mouse_position()));
	
	# If a valid path is found, update the current path
	if id_path.is_empty() == false:
		current_id_path = id_path
		
		
func _physics_process(_delta: float) -> void:
	# Exit if no path exists
	if current_id_path.is_empty():
		return
	
	# Set target position and start moving
	if is_moving == false:
		target_position = tile_map.map_to_local(current_id_path.front())
		is_moving = true
		
	# Move towards target position
	node.position = node.position.move_toward(target_position, 1)
	
	# Makes the player stop moving if they reach the movement limit
	if count == movement_limit:
		current_id_path.clear()
		is_moving = false
		count = 0
	
	# When reaching a point, move to the next or stop if path is done
	if node.position == target_position:
		current_id_path.pop_front()
		count += 1
		
		if current_id_path.is_empty() == false:
			target_position = tile_map.map_to_local(current_id_path.front())
		else:
			count = 0
			is_moving = false
	
	
