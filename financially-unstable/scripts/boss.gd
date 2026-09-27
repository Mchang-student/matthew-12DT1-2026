extends CharacterBody2D

const BOSS_MAX_HEALTH : int = 300 			#Starting and max health for the boss

var player : CharacterBody2D 		#Reference to the player node
var health : int = 300 				#Current health
var max_health : int = 300			#Health Cap
var is_phase_two : bool = false 	#Tracks if the boss has entered phase two
var can_throw : bool = true 		#Tracks if the boss is off money-throw cooldown
var can_spawn_fries : bool = true 	#Tracks if  the boss is off fry-spawn cooldown

@export var health_ui : ProgressBar 	#Health bar UI
@export var pivot : Node2D 				#Node used to aim/rotate toward the player
@export var money_spawn : Marker2D 		#Spawn point for the money thrown projectiles
@export var money_scene: PackedScene 	#Scene for the money projectile
@export var throw_cooldown: float = 1.8  #Time between fry spawns

@export var fry_spawn_point: PathFollow2D   	 #Spawn point for fries
@export var fry_scene: PackedScene 	 			#Scene for the fry enemy
@export var fry_spawn_cooldown: float = 2.0 	#Time between fry spawns

func _ready() -> void:
	# Find the player node from the "player" group
	for node in get_tree().get_nodes_in_group("player"):
		player = node
	health_ui.max_value = health
	health_ui.min_value = 0
	health_ui.value = health


func _process(delta: float) -> void:
	if player == null:
		return

	# Always face the player
	pivot.look_at(player.global_position)
	
	# Switch to phase two once health drops to half
	if not is_phase_two and health <= max_health / 2:
		_enter_phase_two()
	
	if can_throw:
		_throw_money()
	
	if is_phase_two and can_spawn_fries:
		_spawn_fries()


func _throw_money() -> void:
	can_throw = false
	var money = money_scene.instantiate()
	var direction = (player.global_position - money_spawn.global_position).normalized()
	money.rotation = direction.angle()
	money.global_position = money_spawn.global_position
	add_sibling(money)
	await get_tree().create_timer(throw_cooldown).timeout
	can_throw = true


func _enter_phase_two() -> void:
	#Ramp up difficulty for phase two
	is_phase_two = true
	#Change colour of Banks to indicate increased difficulty
	modulate = Color(1.0, 0.4, 0.4)
	throw_cooldown = 1.0


func _spawn_fries() -> void:
	can_spawn_fries = false
	fry_spawn_point.progress_ratio = randf_range(0.0, 1.0)
	var fry = fry_scene.instantiate()
	fry.global_position = fry_spawn_point.global_position
	get_parent().add_child(fry)
	await get_tree().create_timer(fry_spawn_cooldown).timeout
	can_spawn_fries = true


func take_damage(amount: int) -> void:
	#Validate input: ignore invalid (negative or zero) damage amounts
	if amount <= 0:
		return

	health -= amount
	health = clamp(health, 0, max_health)
	health_ui.value = health
	print("banks health: ", health)
	if health <= 0:
		queue_free()
		get_tree().call_deferred("change_scene_to_file", "res://scenes/win_screen.tscn")
