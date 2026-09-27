extends Area2D
var enemies_remaining: int = 0   	#Number of enemies still alive in the level 

func _ready() -> void:
	#Car starts locked until all enemies are defeated
	monitoring = false

	#Count enemies currently in the level
	for enemy in get_tree().get_nodes_in_group("enemy"):
		enemies_remaining += 1
		enemy.tree_exited.connect(_on_enemy_defeated)
	print("Members: ", get_tree().get_nodes_in_group("enemy"))
	print("Enemies found: ", enemies_remaining)

	#Unclok the car if all enemies are defeated or if the level has no enemies
	if enemies_remaining == 0:
		_unlock_car()


func _on_enemy_defeated() -> void:
	enemies_remaining -= 1
	print("Enemy defeated. Remaining: ", enemies_remaining)
	if enemies_remaining <= 0:
		_unlock_car()


func _unlock_car() -> void:
	#Enable collisions and reset visuals now the car is usable
	monitoring = true
	modulate = Color(1, 1, 1)
	print("Car unlocked!")
