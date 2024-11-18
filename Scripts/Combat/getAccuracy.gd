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

	# Calculate the distance between player and enemy's centers
	var center_distance: float = player_pos.distance_to(enemy_pos)
	
	return max(center_distance, 0)  # Ensure the distance isn't negative

# Calculate the hit chance based on the distance between player and enemy
static func get_hit_chance(player: Node2D, enemy: Node2D) -> float:
	var distance = get_distance_to_enemy(player, enemy)
	var distance_factor = clamp(1.0 - (distance / max_distance), 0, 1)
	return lerp(min_accuracy, max_accuracy, distance_factor)

