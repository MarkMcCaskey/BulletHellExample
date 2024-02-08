class_name Player3D extends CharacterBody3D

@export_category("Player")
@export_range(1, 40000, 1) var speed: float = 200 # m/s
@export_range(10, 80000, 1) var acceleration: float = 400 # m/s^2

@export_range(0.1, 10.0, 0.1) var jump_height: float = 6 # m
@export_range(0.1, 3.0, 0.1, "or_greater") var camera_sens: float = 1

@export var health: float = 100.0:
	get: return health
	set(v):
		emit_signal("player_health_changed", health, v)
		health = v

# TODO: 3D bullet
var bullet: PackedScene = preload("res://Entities/player_bullet_3d.tscn")

signal player_health_changed(old: float, new: float)

var jumping: bool = false
var mouse_captured: bool = false

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

var move_dir: Vector2 # Input direction for movement
var look_dir: Vector2 # Input direction for look/aim

var walk_vel: Vector3 # Walking velocity 
var grav_vel: Vector3 # Gravity velocity 
var jump_vel: Vector3 # Jumping velocity

@onready var camera: Camera3D = $Camera
@onready var bullet_spawn_location: Node3D = $Camera/model12_shotgun/BulletSpawnLocation
@onready var bullet_spawn_target: Node3D = $Camera/model12_shotgun/BulletSpawnTarget
@onready var hurtbox: Area3D = $Hurtbox
@onready var hurtbox_shape: CollisionShape3D = $Hurtbox/CollisionShape3D
@onready var chromatic_aberation_effect: ColorRect = $Camera/CanvasLayer/ColorRect
@onready var ui = $CanvasLayer/UI
@onready var shotgun: Model12Shotgun = $Camera/model12_shotgun

func _ready() -> void:
	capture_mouse()

# HACK: change this back to unhandled later
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("exit"): get_tree().quit()
	if health <= 0:
		release_mouse()
		return
	if event is InputEventMouseMotion:
		look_dir = event.relative * 0.001
		if mouse_captured: _rotate_camera()
	if Input.is_action_just_pressed("jump"): jumping = true
	if Input.is_action_just_pressed("shoot"): player_shoot()

func _physics_process(delta: float) -> void:
	if mouse_captured: _handle_joypad_camera_rotation(delta)
	velocity = _walk(delta) + _gravity(delta) + _jump(delta)
	move_and_slide()

func capture_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_captured = true

func release_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mouse_captured = false

func _rotate_camera(sens_mod: float = 1.0) -> void:
	camera.rotation.y -= look_dir.x * camera_sens * sens_mod
	camera.rotation.x = clamp(camera.rotation.x - look_dir.y * camera_sens * sens_mod, -1.5, 1.5)

func _handle_joypad_camera_rotation(delta: float, sens_mod: float = 1.0) -> void:
	var joypad_dir: Vector2 = Input.get_vector("look_left","look_right","look_up","look_down")
	if joypad_dir.length() > 0:
		look_dir += joypad_dir * delta
		_rotate_camera(sens_mod)
		look_dir = Vector2.ZERO

func _walk(delta: float) -> Vector3:
	move_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backwards")
	var _forward: Vector3 = camera.global_transform.basis * Vector3(move_dir.x, 0, move_dir.y)
	var walk_dir: Vector3 = Vector3(_forward.x, 0, _forward.z).normalized()
	walk_vel = walk_vel.move_toward(walk_dir * speed * move_dir.length(), acceleration * delta)
	return walk_vel

func _gravity(delta: float) -> Vector3:
	grav_vel = Vector3.ZERO if is_on_floor() else grav_vel.move_toward(Vector3(0, velocity.y - gravity, 0), gravity * delta)
	return grav_vel

func _jump(delta: float) -> Vector3:
	if jumping:
		if is_on_floor(): jump_vel = Vector3(0, sqrt(4 * jump_height * gravity), 0)
		jumping = false
		return jump_vel
	jump_vel = Vector3.ZERO if is_on_floor() else jump_vel.move_toward(Vector3.ZERO, gravity * delta)
	return jump_vel

func die() -> void:
	call_deferred("_die_inner")

func _die_inner() -> void:
	hide()
	hurtbox.monitorable = false
	hurtbox.monitoring = false
	hurtbox_shape.disabled = true

var camera_shake_intensity: float = 10.0

func player_damage_taken() -> void:
	var extent = ((100 - max(health, 0)) / 10)
	chromatic_aberation_effect.material.set_shader_parameter("r_displacement", Vector2(extent, extent / 3))
	chromatic_aberation_effect.material.set_shader_parameter("b_displacement", Vector2(extent * -1, extent / -3))
	for i in range(6):
		var x_val = randf() * camera_shake_intensity - camera_shake_intensity / 2
		var y_val = randf() * camera_shake_intensity - camera_shake_intensity / 2
		camera.h_offset = x_val
		camera.v_offset = y_val
		chromatic_aberation_effect.material.set_shader_parameter("r_displacement", Vector2(extent * y_val, (extent * x_val) / 3))
		chromatic_aberation_effect.material.set_shader_parameter("b_displacement", Vector2(extent * y_val * -1, (extent * x_val) / -3))
		await get_tree().create_timer(0.05).timeout
	chromatic_aberation_effect.material.set_shader_parameter("r_displacement", Vector2(extent / 3, extent / 6))
	chromatic_aberation_effect.material.set_shader_parameter("b_displacement", Vector2(extent / -3, extent / -6))
	camera.h_offset = 0
	camera.v_offset = 0

func _on_player_health_changed(old: float, new: float) -> void:
	ui.player_hp = new
	if old > new:
		player_damage_taken()
	if new <= 0:
		ui.player_lose()

func player_win() -> void:
	ui.player_win()

func player_shoot() -> void:
	if shotgun.state == Model12Shotgun.ShotgunState.Ready:
		shotgun.shoot()
		var scene = bullet.instantiate()
		# HACK:
		get_parent().get_parent().add_child(scene)
		scene.speed = bullet_spawn_location.global_position.direction_to(bullet_spawn_target.global_position).normalized() * 250
		scene.speed += velocity
		scene.global_position = bullet_spawn_location.global_position

func _on_model_12_shotgun_pump_finished() -> void:
	pass # Replace with function body.

func _on_model_12_shotgun_shot_finished() -> void:
	shotgun.pump()
