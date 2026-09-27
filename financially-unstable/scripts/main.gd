extends Node

var level: int = 1  	 	# Current level number
var current_level_root: Node = null 	 # Reference to the currently loaded level's root node

func _ready() -> void:
	current_level_root = get_node("LevelRoot")
	load_level(level)


func load_level(new_level: int) -> void:
	if current_level_root:
		#Grab the old player's stats before the level (and its player) is destroyed
		var old_player = get_tree().get_first_node_in_group("player")
		if old_player:
			PlayerData.health = old_player.health
			PlayerData.rage = old_player.rage
		current_level_root.queue_free()

	#Load and instantiate the new level scene
	var level_path = "res://scenes/level_%s.tscn" % new_level
	var new_level_root = load(level_path).instantiate()
	current_level_root = new_level_root
	add_child(current_level_root)
	current_level_root.name = "LevelRoot"
	setup_level(current_level_root)


func setup_level(level_root: Node) -> void:
	#Connect to the car's signal so we know when the player can move to the next level
	var car = level_root.get_node_or_null("Car")
	print("Looking for car ... found: ", car)
	if car:
		car.body_entered.connect(_on_car_body_entered)
		print("Car signal connected")


# Signal handlers
func _on_car_body_entered(body: Node2D) -> void:
	#Advance to the next level once the player enters the unlocked car
	if body.is_in_group("player"):
		level += 1
		call_deferred("load_level", level)
