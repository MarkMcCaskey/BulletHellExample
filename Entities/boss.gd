class_name Boss extends Node2D

@export var health: float = 100.0
@export var move_speed: float = 38.0

@onready var bullet_spawn_location: Marker2D = $BulletSpawnLocation

var target: Player
var bullet: PackedScene = preload("res://Entities/bullet.tscn")
var moving_right: bool = true

func _physics_process(delta: float) -> void:
	moving_right = target.global_position.x > global_position.x
	if moving_right:
		global_position += Vector2(move_speed * delta, 0)
	else:
		global_position -= Vector2(move_speed * delta, 0)

func _ready() -> void:
	for p in get_tree().get_nodes_in_group("player"):
		if p is Player:
			target = p
			break
	assert(target != null, "Can't find player")

func shoot_at_player() -> void:
	print("shooting at player")
	var scene = bullet.instantiate()
	scene.global_position = bullet_spawn_location.global_position
	#global_position - target.global_position
	#var angle_to_player = get_angle_to(target.global_position)
	get_parent().add_child(scene)


func _on_shoot_timer_timeout() -> void:
	shoot_at_player()

func _on_collision_area_area_entered(area: Area2D) -> void:
	print("HIT!")
	print(area.name)
	pass # Replace with function body.
