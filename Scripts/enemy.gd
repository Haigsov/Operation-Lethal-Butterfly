extends Unit

#@onready var ray_cast: RayCast2D = $RayCast2D
@onready var units : Array[Unit]
@onready var player: Ally
@onready var area : Area2D = $Area2D
@onready var initiative_tracker: InitiativeTracker = get_parent().get_node("InitiativeTracker")
@onready var vision_cone_area: Area2D = $VisionCone2D/VisionConeArea
#@onready var vision_cone: VisionCone2D = $VisionConeArea
@onready var cone_radius: float = 45.0
@onready var rays: int = 50
@onready var raycast : RayCast2D

const textWriter  = preload("res://Scripts/textWriter.gd");
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready();
	gridMovementModule.is_click_to_move_enabled = false;
	initiativeModule.on_turn_start.connect(superdumbai);
	initiativeModule.initiativeName = "GenericEnemy"
	
	#Getting info for _on_area_2d_mouse_entered() function
	player = get_parent().get_node("Ally")
	area.mouse_entered.connect(_on_area_2d_mouse_entered)
	
	#Raycast
	var curr_angle = -cone_radius  # Start angle for the cone
	
	for i in range(rays):
		raycast = RayCast2D.new()
		raycast.position = Vector2.ZERO
		raycast.scale = Vector2(0.1, 0.1)
		raycast.rotation_degrees = curr_angle - 158.5
		curr_angle += cone_radius / rays  # Increment the angle for each ray
		raycast.set_collision_mask_value(2, true)
		raycast.set_collision_mask_value(1, false)
		raycast.enabled = true
		# raycast.set_collision_layer(1, true)


		# Add the raycast as a child of the current node
		add_child(raycast)

		# Connect the raycast's "area_entered" signal to the receiver function
		# if raycast.is_colliding():
		# 	print("Player is in vision cone")
		# 	_on_area_entered()
	
	#vision_cone_area.body_entered.connect(_on_vision_cone_body_entered)

func _physics_process(_delta: float) -> void:
	if raycast.is_colliding():
			print("Player is in vision cone")
			_on_area_entered()

func superdumbai(_parent):
	textWriter.spawn_toast(get_tree().root, global_position + Vector2(0, -32), "It's my turn!", Color.RED);
	await get_tree().create_timer(1.5).timeout
	textWriter.spawn_toast(get_tree().root, global_position + Vector2(0, -32), "But I dont have an AI yet...", Color.RED);
	await get_tree().create_timer(1.5).timeout
	textWriter.spawn_toast(get_tree().root, global_position + Vector2(0, -32), "So I'm just gonna end my turn now.", Color.RED);
	await get_tree().create_timer(1.5).timeout
	initiativeModule.end_turn();


func _on_area_2d_mouse_entered() -> void:
	if initiative_tracker.get_active_unit() != player:
		return
	var hovered_unit : Unit = self
	var accuracy = Accuracy.get_hit_chance(player, hovered_unit)
	print("Chance of hitting enemy is: " + str(accuracy))
	
func _on_area_entered():
	units = find_units()
	print(units)
	player.gridMovementModule.is_click_to_move_enabled = false;
	units[0].initiativeModule.start_combat(units);
	

#func _on_vision_cone_body_entered():
	#units = find_units()
	#print(units)
	#units[0].initiativeModule.start_combat(units)

#func _check_ally_collision():
	#if ray_cast.get_collider() == player:
		#units[0].initiativeModule.start_combat(units)


func find_units():
	units = []
	var parent = get_parent()
	
	for child in parent.get_children():
		if child is Unit:
			units.append(child)
