extends CharacterBody2D

var speed: float = 250.0
var player : CharacterBody2D
var health: int = 30
var can_attack: bool = true

@export var damage: int = 5
@export var health_ui: ProgressBar
@export var attack_area : Area2D
@export var attack_cooldown : float = 1.0

func _ready() -> void:
	for node in get_tree().get_nodes_in_group("player"):
		player =node
	health_ui.max_value = health
	health_ui.min_value = 0
	health_ui.value = health

func _process(delta: float) -> void:
	if not player == null:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()

func _physics_process(delta: float) -> void:
	if can_attack and player != null and player in attack_area.get_overlapping_bodies():
		_attack()

func _attack() -> void:
	can_attack = false
	player.take_damage(damage)
	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true

func take_damage(amount: int) -> void:
	health -= amount
	health_ui.value = health
	print("enemy health: ", health)
	if health <= 0:
		queue_free()
		
func _damage_player(body: Node2D) -> void:
	if body == player:
		player.take_damage(damage)
