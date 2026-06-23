extends CharacterBody2D

var speed: float = 250.0
var player : CharacterBody2D
var health: int = 3

@export var damage: int = 5

func _ready() -> void:
	for node in get_tree().get_nodes_in_group("player"):
		player =node


func _process(delta: float) -> void:
	if not player == null:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		
		move_and_slide()
		
func take_damage() -> void:
	if health > 0:
		health -= 1
	else:
		queue_free()
		
func _damage_player(body: Node2D) -> void:
	if body == player:
		player.take_damage(damage)
