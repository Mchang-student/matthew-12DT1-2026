extends Area2D

var speed: float = 700.0
var stopped: bool = false
var lifetime: float = 0.0
var max_lifetime: float = 3.0
@export var damage: int = 8

func _process(delta: float) -> void:
	if not stopped:
		lifetime += delta
		move_local_x(speed * delta)
		if lifetime >= max_lifetime:
			stopped = true
			queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.take_damage(damage)
		queue_free()
