extends Area2D
var enemies_remaining: int = 0

func _ready() -> void:
	monitoring = false

	for enemy in get_tree().get_nodes_in_group("enemy"):
		enemies_remaining += 1
		enemy.tree_exited.connect(_on_enemy_defeated)
	print("Members: ", get_tree().get_nodes_in_group("enemies"))
	print("Enemies found: ", enemies_remaining)

	if enemies_remaining == 0:
		_unlock_car()

func _on_enemy_defeated() -> void:
	enemies_remaining -= 1
	print("Enemy defeated. Remaining: ", enemies_remaining)
	if enemies_remaining <= 0:
		_unlock_car()

func _unlock_car() -> void:
	monitoring = true
	modulate = Color(1, 1, 1)
	print("Car unlocked!")
