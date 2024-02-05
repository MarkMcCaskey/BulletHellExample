class_name Boss extends Node2D

@export var health: float = 100.0:
	get: return health
	set(v):
		if v <= 0:
			emit_signal("boss_died")
		else:
			emit_signal("boss_hit")
		health = v

@export var move_speed: float = 38.0

@onready var bullet_spawn_location: Marker2D = $BulletSpawnLocation
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var target: Player
var bullet: PackedScene = preload("res://Entities/bullet.tscn")
var moving_right: bool = true

signal boss_died()
signal boss_hit()

func _physics_process(delta: float) -> void:
	if health <= 0: return
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
	var scene = bullet.instantiate()
	scene.global_position = bullet_spawn_location.global_position
	#global_position - target.global_position
	#var angle_to_player = get_angle_to(target.global_position)
	get_parent().add_child(scene)


func _on_shoot_timer_timeout() -> void:
	if health > 0:
		shoot_at_player()

func _on_boss_hit() -> void:
	animation_player.play("Hit")
	pass # Replace with function body.

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Dead":
		queue_free()

func _on_boss_died() -> void:
	animation_player.play("Dead")
