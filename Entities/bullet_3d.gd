class_name Bullet3D extends Node3D

@export var damage: float = 10.0
@export var speed: Vector3 = Vector3(0, 0, 100.0)
@export var rotation_speed: float = 6
#@export var rotation: float = 0

@onready var delete_after_animation: bool = false
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("Spawn")
	#animation_tree["parameters/playback"].travel("Spawn")
	#apply_impulse(Vector2(), Vector2(speed, 0).rotated(rotation))

func _physics_process(delta: float) -> void:
	global_position += speed * delta
	global_rotation.y += rotation_speed * delta
	#debug_label.text = animation_tree.animat

func _on_area_3d_area_entered(area: Area3D) -> void:
	var parent = area.get_parent()
	if parent is Player3D:
		# TODO: clean this up
		parent.health -= damage
	animation_player.play("Hit")
	delete_after_animation = true

func _on_timer_timeout() -> void:
	animation_player.play("Fade")
	delete_after_animation = true

func _on_area_3d_body_entered(_body: Node3D) -> void:
	#queue_free()
	animation_player.play("Hit")
	delete_after_animation = true


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if delete_after_animation || (anim_name == "Hit" || anim_name == "Fade"):
		queue_free()

