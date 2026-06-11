extends CharacterBody2D

var speed: float = 300.0
@export var pivot: Node2D

func _process(delta: float) -> void:
	var direction: Vector2 = Vector2(0.0, 0.0)
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = Input.get_axis("ui_up", "ui_down")
	velocity = speed * direction.normalized()
	move_and_slide()
	
	pivot.look_at(get_global_mouse_position())
