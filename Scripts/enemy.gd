extends Unit

@onready var units : Array[Unit]
@onready var player: Ally
@onready var area : Area2D = $Area2D
@onready var initiative_tracker: InitiativeTracker = get_parent().get_node("InitiativeTracker")
@onready var accuracy : float

# Raycast
@onready var raycast : RayCast2D
@onready var cone_radius: float = 45.0
@onready var rays: int = 50

# Buttons
@onready var beginCombatBtn
@onready var moveBtn
@onready var endTurnBtn
@onready var endCombatBtn

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

	# player getting hit chance
	area.input_pickable = true
	area.input_event.connect(_getting_hit_chance)
	

	# Setting buttons
	beginCombatBtn = get_parent().get_node("Ally").get_node("Camera2D").get_node("TestingMenu").get_node("BeginCombat")
	moveBtn = get_parent().get_node("Ally").get_node("Camera2D").get_node("TestingMenu").get_node("Move")
	endTurnBtn = get_parent().get_node("Ally").get_node("Camera2D").get_node("TestingMenu").get_node("End Turn")
	endCombatBtn = get_parent().get_node("Ally").get_node("Camera2D").get_node("TestingMenu").get_node("End Combat")

	#Raycast
	var curr_angle = -cone_radius  # Start angle for the cone
	
	# Creates a 45 degree angle cone by creating 50 rays covering the degree range
	for i in range(rays):
		raycast = RayCast2D.new()
		raycast.position = Vector2.ZERO
		raycast.scale = Vector2(0.1, 0.1) # Scale the raycast to be very small
		raycast.rotation_degrees = curr_angle - 158.5 # Set the angle to be in front of the enemy
		curr_angle += cone_radius / rays  # Increment the angle for each ray
		raycast.set_collision_mask_value(2, true) # Set the collision mask to only collide with the player
		raycast.set_collision_mask_value(1, false) # Set the collision mask to not collide with the enemy
		raycast.collide_with_areas = true
		raycast.enabled = true
		# raycast.set_collision_layer(1, true)


		# Add the raycast as a child of the current node
		add_child(raycast)


func _physics_process(_delta: float) -> void:
	# Enters combat when player is detected
	if raycast.is_colliding():
			print("Player got detected!")
			enemy_detection_combat_start()

func superdumbai(_parent):
	textWriter.spawn_toast(get_tree().root, global_position + Vector2(0, -32), "It's my turn!", Color.RED);
	await get_tree().create_timer(1.5).timeout
	textWriter.spawn_toast(get_tree().root, global_position + Vector2(0, -32), "But I dont have an AI yet...", Color.RED);
	await get_tree().create_timer(1.5).timeout
	textWriter.spawn_toast(get_tree().root, global_position + Vector2(0, -32), "So I'm just gonna end my turn now.", Color.RED);
	await get_tree().create_timer(1.5).timeout
	initiativeModule.end_turn();


# Shows the hit chance of the player when the enemy is hovered
func _on_area_2d_mouse_entered() -> void:
	if initiative_tracker.get_active_unit() != player:
		return
	var hovered_unit : Unit = self
	accuracy = Accuracy.get_hit_chance(player, hovered_unit)
	print("Chance of hitting enemy is: " + str(accuracy))
	
# Starts combat when player is detected
func enemy_detection_combat_start():
	units = find_units()
	player.gridMovementModule.is_click_to_move_enabled = false
	units[0].initiativeModule.start_combat(units)
	
	
	# disables buttons
	beginCombatBtn.disabled = true
	moveBtn.disabled = false
	endTurnBtn.disabled = false
	endCombatBtn.disabled = false
	

# Finds all units in the scene
func find_units() -> Array[Unit]:
	units = []
	var parent = get_parent()
	
	for child in parent.get_children():
		if child is Unit:
			units.append(child)
	
	return units

# Getting hit chance for player
func _getting_hit_chance(_viewport, event, _shape_idx):
	if initiative_tracker.get_active_unit() != player:
		return
	var hovered_unit : Unit = self
	accuracy = Accuracy.get_hit_chance(player, hovered_unit)
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		accuracy = Accuracy.get_hit_chance(player, self)
		if randf() <= accuracy:
			self.stats.current_health -= 1
			print("Hit for 1 damage")
			print("Enemy health: " + str(self.stats.current_health))
		else:
			print("Missed")
