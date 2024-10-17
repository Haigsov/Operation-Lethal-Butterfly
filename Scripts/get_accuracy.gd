extends Node2D

@onready var enemy: CharacterBody2D = get_parent().get_node("Enemy")
@onready var player: CharacterBody2D = get_parent().get_node("Player")

var max_distance = 500  # Maximum range of the firearm
var min_accuracy = 0.01  # Minimum accuracy at max distance (1%)
var max_accuracy = 0.95  # Maximum accuracy when close (95%)

func _ready():
	if player and enemy:
		var distance: float = get_distance_to_enemy()
		print("Adjusted Distance: ", distance)
		var hit_chance: float = get_hit_chance(distance)
		print("Hit Chance: ", hit_chance)
	else:
		print("Player or Enemy is not initialized!")

func get_distance_to_enemy() -> float:
	# Get the global positions of player and enemy
	var player_pos: Vector2 = player.global_position
	var enemy_pos: Vector2 = enemy.global_position
	
	# Assuming both player and enemy have a CircleShape2D
	var player_radius: float = get_collision_radius(player)
	var enemy_radius: float = get_collision_radius(enemy)

	# Calculate the distance between player and enemy's centers
	var center_distance: float = player_pos.distance_to(enemy_pos)

	# Subtract the radii to get the distance from the player's edge to the enemy's edge
	var edge_to_edge_distance: float = center_distance - (player_radius + enemy_radius)
	
	return max(edge_to_edge_distance, 0)  # Ensure the distance isn't negative

func get_collision_radius(character: CharacterBody2D) -> float:
	var collision_shape: CollisionShape2D = character.get_node("CollisionShape2D")
	var shape = collision_shape.shape
	
	if shape is CircleShape2D:
		return shape.radius
	else:
		# Handle other shapes if necessary (e.g. rectangles, polygons)
		return 0


func get_hit_chance(distance: float) -> float:
	var distance_factor = clamp(1.0 - (distance / max_distance), 0, 1)
	return lerp(min_accuracy, max_accuracy, distance_factor)
