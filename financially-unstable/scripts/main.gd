extends Node

var level: int = 1
var current_level_root: Node = null

func _ready() -> void:
	current_level_root = get_node("LevelRoot")
	load_level(level)

func load_level(new_level: int) -> void:
	if current_level_root:
		current_level_root.queue_free()

	var level_path = "res://scenes/level_%s.tscn" % new_level
	var new_level_root = load(level_path).instantiate()
	current_level_root = new_level_root
	add_child(current_level_root)
	current_level_root.name = "LevelRoot"
	setup_level(current_level_root)

func setup_level(level_root: Node) -> void:
	var car = level_root.get_node_or_null("Car")
	print("Looking for car ... found: ", car)
	if car:
		car.body_entered.connect(_on_car_body_entered)
		print("Car signal connected")

# signal handlers
func _on_car_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		level += 1
		call_deferred("load_level", level)
