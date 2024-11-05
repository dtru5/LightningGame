extends Area2D

signal update_score

var power_up_scene = preload("res://scenes/power_up_1.tscn")

func die() -> void:
	emit_signal("update_score")
	var ranNum: int = randi_range(1,5)
	if ranNum == 2:
		var power_up_instance = power_up_scene.instantiate()
		get_tree().current_scene.add_child(power_up_instance)
		power_up_instance.global_position = global_position
	queue_free()
	
func _on_body_entered(body) -> void:
	body.hurt_player()
	die()
