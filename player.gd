extends CharacterBody2D

@onready var tile_map = $"../TileMap"

# AStarGrid2D is a grid used for pathfinding over the tile map, storing coordinates of tiles.
var astar_grid: AStarGrid2D
var current_id_path: Array[Vector2i]
var current_point_path: PackedVector2Array
var target_position: Vector2
var is_moving: bool

func _ready() -> void:
	# intialize astar_grid
	astar_grid = AStarGrid2D.new()
	# Set the region of astar_grid to match the used area of the tile_map
	astar_grid.region = tile_map.get_used_rect()
	# Set the cell size to 16x16 (adjustable depending on tile size)
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
			var tile_data = tile_map.get_cell_tile_data(0, tile_position)
			
			if tile_data == null or tile_data.get_custom_data("walkable") == false:
				astar_grid.set_point_solid(tile_position)
	
func _input(event: InputEvent) -> void:
	# Check if the 'move' action is pressed
	if event.is_action_pressed("move") == false:
		return
	
	var id_path 
	
	# Determine path based on whether the character is currently moving
	if is_moving:
		id_path = astar_grid.get_id_path(
			tile_map.local_to_map(target_position),
			tile_map.local_to_map(get_global_mouse_position())
		)
	else:
		id_path = astar_grid.get_id_path(
			tile_map.local_to_map(global_position),
			tile_map.local_to_map(get_global_mouse_position())
		).slice(1)
	
	# If a valid path is found, update the current path
	if id_path.is_empty() == false:
		current_id_path = id_path
		
		# Retrieve point-based path for precise movement
		current_point_path = astar_grid.get_point_path(
			tile_map.local_to_map(target_position),
			tile_map.local_to_map(get_global_mouse_position())
		)
		
	# Adjust path points to account for tile center offset
	for i in current_point_path.size():
		current_point_path[i] = current_point_path[i] + Vector2(8, 8)

func _physics_process(_delta: float) -> void:
	# Exit if no path exists
	if current_id_path.is_empty():
		return
	
	# Set target position and start moving
	if is_moving == false:
		target_position = tile_map.map_to_local(current_id_path.front())
		is_moving = true
	
	# Move towards target position
	global_position = global_position.move_toward(target_position, 1)
	
	# When reaching a point, move to the next or stop if path is done
	if global_position == target_position:
		current_id_path.pop_front()
		
		if current_id_path.is_empty() == false:
			target_position = tile_map.map_to_local(current_id_path.front())
		else:
			is_moving = false
	
	
