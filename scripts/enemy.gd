extends Area2D

signal update_score

@export var speed_x: int = 280
@export var speed_y: int = 40
@export var rotation_speed: float = 0.05
@export var enemy_flying_direction: int = randi_range(-1, 1)
@export var acceleration: int = 3

const power_up_scene = preload("res://scenes/power_up_1.tscn")

func _physics_process(delta: float) -> void:
	rotate(rotation_speed * delta)
	
	if (global_position.x < 1000):
		global_position.x += -speed_x*delta*acceleration
		global_position.y += speed_y*delta*acceleration*enemy_flying_direction
	else:
		global_position.x += -speed_x*delta
		global_position.y += -speed_y*delta*enemy_flying_direction
	
func die() -> void:
	emit_signal("update_score")
	var ranNum: int = randi_range(1,5)
	if ranNum == 3:
		var power_up_instance = power_up_scene.instantiate()
		get_tree().current_scene.add_child(power_up_instance)
		power_up_instance.global_position = global_position
	queue_free()
	
func _on_body_entered(body) -> void:
	body.hurt_player()
	die()
