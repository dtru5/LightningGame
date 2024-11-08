extends CharacterBody2D

signal collision_with_enemy
signal health_powerup

const start_speed: int = 0
const move_speed: int = 800
const falling_speed: int = 10
const area_width: int = 1280
const area_height: int = 720
var rocket_time_limiter: float = 0.28

var is_rocket_blocked = false
var rocket_scene = preload("res://scenes/rocket.tscn")
@onready var rocket_container: Node = get_node("RocketContainer")

@onready var rapid_fire_timer : Node = get_node("rapid_fire_timer")

@onready var player_shoot_sound = $"../SFX/PlayerShootSound"

func _process(_delta) -> void:
	shoot()

func _physics_process(_delta) -> void:
	limit_area_movement(area_width, area_height)
	movement_config()
	move_and_slide()

func set_inertia(speed: int, falling: int) -> Vector2:
	return Vector2(speed, randi()%falling+1)

func movement_config() -> void:
	velocity = set_inertia(start_speed, falling_speed)
	
	if Input.is_action_pressed("up") or Input.is_action_pressed("up_kb"): 
		velocity.y = -move_speed
	if Input.is_action_pressed("down") or Input.is_action_pressed("down_kb"): 
		velocity.y = move_speed
	if Input.is_action_pressed("right") or Input.is_action_pressed("right_kb"): 
		velocity.x = move_speed-200
	if Input.is_action_pressed("left") or Input.is_action_pressed("left_kb"): 
		velocity.x = -move_speed+200
	
func limit_area_movement(width: int, height: int) -> void:
	if global_position.x < 0: 
		global_position.x = 0
	if global_position.y < 0: 
		global_position.y = 0
		
	if global_position.x > width:  
		global_position.x = width
	if global_position.y > height: 
		global_position.y = height
		
func shoot() -> void:
	var rocket_instance: Area2D = rocket_scene.instantiate()
	
	if Input.is_action_pressed("shoot") && is_rocket_blocked == false:
		player_shoot_sound.play()
		rocket_container.add_child(rocket_instance)
		rocket_instance.global_position = global_position
		rocket_instance.global_position.x += 110
		
		is_rocket_blocked = true
		await get_tree().create_timer(rocket_time_limiter).timeout
		is_rocket_blocked = false 
		
func enable_rapid_fire() -> void:
	rocket_time_limiter = 0.1
	rapid_fire_timer.start(3)
	
func hit_health_powerup() -> void:
	emit_signal("health_powerup")
	
func _on_rapid_fire_timer_timeout():
	rocket_time_limiter = 0.28
	
func hurt_player() -> void:
	emit_signal("collision_with_enemy")

func die() -> void:
	queue_free()
