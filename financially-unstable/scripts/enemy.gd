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
		look_at(player.global_position)
		velocity = Vector2(1,0) .rotated(rotation) * speed
		
		move_and_slide()
		
func take_damage() -> void:
	if health > 0:
		health -= 1
	else:
		queue_free()
		
func _damage_player(body: Node2D) -> void:
	if body == player:
		player.take_damage(damage)
