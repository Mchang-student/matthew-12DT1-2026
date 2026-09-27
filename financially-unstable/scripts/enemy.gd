extends CharacterBody2D 		

const ENEMY_MAX_HEALTH: int = 30 					#Starting and max health for a regular enemy
const ENEMY_DAMAGE: int = 5 
const ENEMY_ATTACK_COOLDOWN: float = 1.0

var speed: float = 250.0 				#Movement speed while chasing the player
var player : CharacterBody2D 			#Reference to the player node
var health: int = ENEMY_MAX_HEALTH		#Current health
var can_attack: bool = true 			#Tracks if the enemy is off attack cooldwon

@export var damage: int = 5 			#Damage delt per attack
@export var health_ui: ProgressBar 		#Health bar UI
@export var attack_area : Area2D 		#Area used to detect the player in attack range
@export var attack_cooldown : float = 1.0 #Time between attacks

func _ready() -> void:
	#Find the player node from the "player" group
	for node in get_tree().get_nodes_in_group("player"):
		player = node
	health_ui.max_value = health
	health_ui.min_value = 0
	health_ui.value = health


func _process(delta: float) -> void:
	#Chase the player directly
	if not player == null:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()


func _physics_process(delta: float) -> void:
	#Attack if the player is in range and not on cooldwon
	if can_attack and player != null and player in attack_area.get_overlapping_bodies():
		_attack()


func _attack() -> void:
	can_attack = false
	player.take_damage(damage)
	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true


func take_damage(amount: int) -> void:
	#Validate input: ignore invalid (negative or zero) damage amounts
	if amount <= 0:
		return

	health -= amount
	health = clamp(health, 0, ENEMY_MAX_HEALTH)
	health_ui.value = health
	print("enemy health: ", health)
	if health <= 0:
		queue_free()


func _damage_player(body: Node2D) -> void:
	#Deal damage if the colliding body is the player
	if body == player:
		player.take_damage(damage)
