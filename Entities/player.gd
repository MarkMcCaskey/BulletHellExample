class_name Player extends CharacterBody2D

@export var speed: float = 200.0
@export var health: float = 100.0:
	get: return health
	set(v):
		emit_signal("player_health_changed", health, v)
		health = v

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var bullet_spawn_location: Node2D = $BulletSpawnLocation
@onready var hurtbox: Area2D = $Hurtbox
@onready var hurtbox_shape: CollisionShape2D = $Hurtbox/CollisionShape2D

var bullet: PackedScene = preload("res://Entities/player_bullet.tscn")

signal player_health_changed(old: float, new: float)

var direction: Vector2 = Vector2(0,0)

func _ready():
	animation_tree.active = true

func _physics_process(_delta: float) -> void:
	if health <= 0: return
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_vector("move_left", "move_right", "move_forward", "move_backwards")
	if direction.x != 0:
		velocity.x = direction.x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	if direction.y != 0:
		velocity.y = direction.y * speed
	else:
		velocity.y = move_toward(velocity.y, 0, speed)

	move_and_slide()
	#update_animation()
	update_facing_direction()

func _input(event: InputEvent) -> void:
	if health <= 0: return
	# HACK:
	if event.is_action_pressed("jump"):
		player_shoot()

func player_shoot() -> void:
	var scene = bullet.instantiate()
	scene.global_position = bullet_spawn_location.global_position
	# HACK:
	get_parent().get_parent().add_child(scene)

#func update_animation():
#	animation_tree.set("parameters/Move/blend_position", direction.x)
	
func update_facing_direction():
	var is_new_direction: bool = false
	if direction.x > 0:
		is_new_direction = sprite.flip_h != false
		sprite.flip_h = true
	elif direction.x < 0:
		is_new_direction = sprite.flip_h != true
		sprite.flip_h = false
	
	if is_new_direction:
		bullet_spawn_location.position.x *= -1

func die() -> void:
	call_deferred("_die_inner")

func _die_inner() -> void:
	hide()
	hurtbox.monitorable = false
	hurtbox.monitoring = false
	hurtbox_shape.disabled = true
