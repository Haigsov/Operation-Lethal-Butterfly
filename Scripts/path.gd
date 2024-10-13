extends Node2D

#EXTREMELY temporary path drawer. We'll need to make something smarter later.
#gets data from the pathing module; maybe making a child of the pathing module would be intutive, maybe not;
#regardless, not worth dealing with for the MVP -Jody

@onready var pathingmodule = $"../Player/GridMovementModule"

func _process(_delta: float) -> void:
	queue_redraw()
	
func _draw() -> void:
	if (pathingmodule) == null: 
		return
	# check if there is a path to draw before the player moves
	if pathingmodule.current_id_path.is_empty():
		return
	
	# checks if player stops moving
	if pathingmodule.is_moving == false:
		return
		
		
	@warning_ignore("unassigned_variable")
	var drawingPath : Array[Vector2];
	
	for cell in pathingmodule.current_id_path:
		
		var t = pathingmodule.tile_map.map_to_local(cell);
		
		drawingPath.append(Vector2(t.x-8, t.y-8));
	
	
	
	# draws a red line highlighting the player's path
	if (drawingPath.size() > 1):
		draw_polyline(drawingPath, Color.RED)
