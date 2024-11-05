extends Area2D

@export var speed: int = 200  # Speed at which the power-up moves to the left

func _physics_process(delta: float) -> void:
	# Move the power-up left at a steady rate
	global_position.x -= speed * delta

func _on_body_entered(body: Node2D) -> void:
	print("hi\n")
	queue_free()
