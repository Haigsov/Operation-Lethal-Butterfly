extends Node2D

@onready var player = $"../Player"

func _process(_delta: float) -> void:
	queue_redraw()
	
	
		

func _draw() -> void:
	# check if there is a path to draw before the player moves
	if player.current_point_path.is_empty():
		return
	
	# checks if player stops moving
	if player.is_moving == false:
		return
	
	# draws a red line highlighting the player's path
	draw_polyline(player.current_point_path, Color.RED)
