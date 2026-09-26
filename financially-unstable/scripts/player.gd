extends CharacterBody2D

var speed: float = 400.0		#player movement speed
var health : int = 100  		#current health
var is_punching: bool = false	#tracks if the punch animation is currently playing
var rage: float = 0.0			#current rage meter value
var max_rage : float = 100.0	#rage meter cap
var add_rage : float = 20
var is_enraged : bool = false	#tracks if rage mode is active
var max_health : int = 100      #health cap


@export var pivot: Node2D							#node used to aim/rotate toward the mouse
@export var animated_sprite: AnimatedSprite2D		#player sprite animations
@export var health_ui: ProgressBar					#health bar UI
@export var health_label : Label					#health text label
@export var punch_collision: CollisionShape2D		#hitbox that turns on during a punch
@export var rage_ui : ProgressBar					#rage bar UI
@export var punch_damage: int = 10
@export var punch_duration: float = 0.2
@export var normal_speed: float = 400.0
@export var rage_speed: float = 700.0
@export var rage_duration: float = 5.0

func _ready() -> void:
	#restore health and rage carried over from the previous level, if any
	health = PlayerData.health
	rage = PlayerData.rage
	
	#set up health bar and label with restored values
	health_ui.max_value = max_health
	health_ui.value = health
	health_label.text = "" + str(health) + "/" + str(max_health) 
	rage_ui.max_value = max_rage
	rage_ui.value = rage
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_punch"):
		print("mouse clicked")
	var direction: Vector2 = Vector2(0.0, 0.0)
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = Input.get_axis("ui_up", "ui_down")
	#apply movement
	velocity = speed * direction.normalized()
	move_and_slide()
	
	#rotate the pivot to always face the mouse
	pivot.look_at(get_global_mouse_position())
	
	#play the movement or idle animation, but don't interupt the punch animationn
	if direction != Vector2.ZERO and not is_punching: 
		animated_sprite.play("default")
	elif not is_punching:
		animated_sprite.play("idle")
	
	# flip sprite to face the direction of the mouse (left/right), unless punching 
	if not is_punching:
		if get_global_mouse_position().x < global_position.x:
			animated_sprite.flip_h = true
		else:
			animated_sprite.flip_h = false
	
	#trigger punch on input, only if not already punching
	if Input.is_action_just_pressed("ui_punch") and not is_punching:
		_start_punch()

func _start_punch() -> void:
	is_punching = true
	animated_sprite.play("punch")
	print("playing punching animation")
	punch_collision.disabled = false
	#hitbox stays active for the punch_duration time, which is 0.2s
	await get_tree().create_timer(punch_duration).timeout 
	punch_collision.disabled = true
	is_punching = false

func take_damage(amount: int) -> void:
	#take damage when hit, reload the scene when character dies.
	if health > amount:
		health -= amount
		health_label.text = "" + str(health) + "/" + str(max_health)
		health_ui.value = health
	else: 
		get_tree().call_deferred("reload_current_scene")


func _punch(body: Node2D) -> void:
	print("Punch hit: ", body.name) 
	if body.has_method("take_damage"):
		body.take_damage(punch_damage)
		#build rage on a sucessful hit, capped at max_rage
		rage += add_rage		
		rage = min(rage, max_rage) 
		rage_ui.value = rage
		#trigger rage mode once the bar if full
		if rage >= max_rage and not is_enraged: 	
			_activate_rage()
			
func _activate_rage() -> void:
	#temporary speed boost when rage mode is on
	is_enraged = true
	var original_speed = speed
	speed = rage_speed
	print("RAGE ACTIVATED")
	
	var tween = create_tween()
	tween.tween_property(rage_ui, "value", 0.0, rage_duration)
	
	await get_tree().create_timer(rage_duration).timeout 
	#reset speed back to normal 
	speed = original_speed
	is_enraged = false
	#reset rage
	rage = 0.0  
