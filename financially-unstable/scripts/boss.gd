extends CharacterBody2D

var player : CharacterBody2D
var health : int = 150
var max_health : int = 150
var is_phase_two : bool = false
var can_throw : bool = true
var can_spawn_fries : bool = true

@export var health_ui : ProgressBar
@export var pivot : Node2D
@export var money_spawn : Marker2D
@export var money_scene: PackedScene
@export var throw_cooldown: float = 1.8

@export var fry_spawn_point: PathFollow2D    # same as your manager's spawn_point
@export var fry_scene: PackedScene
@export var fry_spawn_cooldown: float = 4.0

func _ready() -> void:
	for node in get_tree().get_nodes_in_group("player"):
		player = node
	health_ui.max_value = health
	health_ui.min_value = 0
	health_ui.value = health

func _process(delta: float) -> void:
	if player == null:
		return
	
	pivot.look_at(player.global_position)
	
	if not is_phase_two and health <= max_health / 2:
		_enter_phase_two()
	
	if can_throw:
		_throw_money()
	
	if is_phase_two and can_spawn_fries:
		_spawn_fries()

func _throw_money() -> void:
	can_throw = false
	var money = money_scene.instantiate()
	money.rotation = pivot.rotation
	money.global_position = money_spawn.global_position
	add_sibling(money)
	await get_tree().create_timer(throw_cooldown).timeout
	can_throw = true

func _enter_phase_two() -> void:
	is_phase_two = true
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
	health -= amount
	health_ui.value = health
	print("banks health: ", health)
	if health <= 0:
		queue_free()
		get_tree().call_deferred("change_scene_to_file", "res://scenes/win_screen.tscn")
