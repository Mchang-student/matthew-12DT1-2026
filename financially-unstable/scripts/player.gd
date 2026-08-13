extends CharacterBody2D

var speed: float = 400.0
var health : int = 100
var is_punching: bool = false
var rage: float = 0.0
var max_rage : float = 100.0
var is_enraged : bool = false



@export var pivot: Node2D
@export var animated_sprite: AnimatedSprite2D
@export var health_ui: ProgressBar
@export var health_label : Label
@export var punch_collision: CollisionShape2D
@export var rage_ui : ProgressBar

func _ready() -> void:
	health_ui.max_value = health
	health_ui.value = health
	health_label.text = "" + str(health) + "/" + str(health) 
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_punch"):
		print("mouse clicked")
	var direction: Vector2 = Vector2(0.0, 0.0)
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = Input.get_axis("ui_up", "ui_down")
	velocity = speed * direction.normalized()
	move_and_slide()
	
	pivot.look_at(get_global_mouse_position())
	
	if direction != Vector2.ZERO and not is_punching:
		animated_sprite.play("default")
	elif not is_punching:
		animated_sprite.play("idle")
	
	if not is_punching:
		if get_global_mouse_position().x < global_position.x:
			animated_sprite.flip_h = true
		else:
			animated_sprite.flip_h = false
	
	if Input.is_action_just_pressed("ui_punch") and not is_punching:
		_start_punch()
		
func _start_punch() -> void:
	is_punching = true
	print("playing punching animation")
	animated_sprite.play("punch")
	punch_collision.disabled = false
	await get_tree().create_timer(0.2).timeout
	punch_collision.disabled = true
	is_punching = false

func take_damage(amount: int) -> void:
	if health > amount:
		health -= amount
		health_label.text = "" + str(health) + "/100"
		health_ui.value = health
	else: 
		get_tree().call_deferred("reload_current_scene")


func _punch(body: Node2D) -> void:
	print("Punch hit: ", body.name) 
	if body.has_method("take_damage"):
		body.take_damage()
		rage += 20.0
		rage = min(rage, max_rage)
		rage_ui.value = rage
		if rage >= max_rage and not is_enraged:
			_activate_rage()
			
func _activate_rage() -> void:
	is_enraged = true
	speed = 700.0
	print("RAGE ACTIVATED")
	await get_tree().create_timer(5.0).timeout
	speed = 400.0
	is_enraged = false
	rage = 0.0 
	rage_ui.value = 0.0
