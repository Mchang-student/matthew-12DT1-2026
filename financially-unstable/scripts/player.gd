extends CharacterBody2D

var speed: float = 400.0
var health : int = 100

@export var pivot: Node2D
@export var animated_sprite: AnimatedSprite2D
@export var health_ui: ProgressBar
@export var health_label : Label

func _ready() -> void:
	health_ui.max_value = health
	health_ui.value = health
	health_label.text = "" + str(health) + "/" + str(health) 
	
func _process(delta: float) -> void:
	var direction: Vector2 = Vector2(0.0, 0.0)
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = Input.get_axis("ui_up", "ui_down")
	velocity = speed * direction.normalized()
	move_and_slide()
	
	pivot.look_at(get_global_mouse_position())
	
	if direction != Vector2.ZERO:
		animated_sprite.play("default")
		if direction.x > 0:
			animated_sprite.flip_h = true
		elif direction.x < 0:
			animated_sprite.flip_h = false
	else: animated_sprite.play("idle")

func take_damage(amount: int) -> void:
	if health > amount:
		health -= amount
		health_label.text = "" + str(health) + "/10"
		health_ui.value = health
	else: 
		get_tree().call_deferred("reload_current_scene")
