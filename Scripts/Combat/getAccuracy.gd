#@onready var enemy: Node2D = $Enemy
#@onready var player: CharacterBody2D = $Ally

class_name Accuracy

static var max_distance = 100  # Maximum range of the firearm
static var min_accuracy = 0.01  # Minimum accuracy at max distance (1%)
static var max_accuracy = 0.95  # Maximum accuracy when close (95%)


static func get_distance_to_enemy(player: Node2D, enemy: Node2D) -> float:
	# Get the global positions of player and enemy
	var player_pos: Vector2 = player.position
	var enemy_pos: Vector2 = enemy.position
	
	## Assuming both player and enemy have a CircleShape2D
	#var player_radius: float = get_collision_radius(player)
	#var enemy_radius: float = get_collision_radius(enemy)

	# Calculate the distance between player and enemy's centers
	var center_distance: float = player_pos.distance_to(enemy_pos)

	# Subtract the radii to get the distance from the player's edge to the enemy's edge
	#var edge_to_edge_distance: float = center_distance - (player_pos + enemy_pos)
	
	return max(center_distance, 0)  # Ensure the distance isn't negative

static func get_hit_chance(player: Node2D, enemy: Node2D) -> float:
	var distance = get_distance_to_enemy(player, enemy)
	var distance_factor = clamp(1.0 - (distance / max_distance), 0, 1)
	return lerp(min_accuracy, max_accuracy, distance_factor)

#func _ready():
	#if player and enemy:
		#var distance: float = get_distance_to_enemy()
		#print("Adjusted Distance: ", distance)
		#var hit_chance: float = get_hit_chance(distance)
		#print("Hit Chance: ", hit_chance)
	#else:
		#print("Player or Enemy is not initialized!")

#static func get_collision_radius(character: CharacterBody2D) -> float:
	#var collision_shape: CollisionShape2D = character.get_node("CollisionShape2D")
	#var shape = collision_shape.shape
	#
	#if shape is CircleShape2D:
		#return shape.radius
	#else:
		## Handle other shapes if necessary (e.g. rectangles, polygons)
		#return 0
