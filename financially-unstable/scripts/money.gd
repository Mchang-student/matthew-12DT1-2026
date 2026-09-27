extends Area2D

var speed: float = 700.0 			#Travel speed of the projectile
var stopped: bool = false 			#Tracks if the projectile has stopped/been destroyed
var lifetime: float = 0.0 			#Time this projectile has existed for
var max_lifetime: float = 3.0 		#How long the projectile lives before dissapearing
@export var damage: int = 8 		#Damage delt to the player on hit

func _process(delta: float) -> void:
	if not stopped:
		lifetime += delta
		move_local_x(speed * delta)
		#Despawn once the projectile has existed too long without hitting anything
		if lifetime >= max_lifetime:
			stopped = true
			queue_free()


func _on_body_entered(body: Node2D) -> void:
	#Damage the player on contact, then remove the projectile
	if body.is_in_group("player"):
		body.take_damage(damage)
		queue_free()
