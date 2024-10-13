extends Node



func on_turn_start():
	print("Looks like its my turn!")
	
	
	
	
# Called when the node enters the scene tree for the first time.
func _ready():
	$InitiativeClient.on_turn_start.connect(on_turn_start)
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
