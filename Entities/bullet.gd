class_name Bullet extends Node2D

@export var damage: float = 10.0
@export var speed: Vector2 = Vector2(5, 100.0)
#@export var rotation: float = 0

@onready var delete_after_animation: bool = false
@onready var animation_tree: AnimationTree = $AnimationTree

func _ready() -> void:
	animation_tree.active = true
	#animation_tree["parameters/playback"].travel("Spawn")
	#apply_impulse(Vector2(), Vector2(speed, 0).rotated(rotation))

func _physics_process(delta: float) -> void:
	global_position += speed * delta
	#debug_label.text = animation_tree.animat

func _on_area_2d_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent is Player:
		# TODO: clean this up
		parent.health -= damage
		animation_tree["parameters/playback"].travel("Hit")
		delete_after_animation = true

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if delete_after_animation || (anim_name == "Hit" || anim_name == "Fade"):
		queue_free()

func _on_timer_timeout() -> void:
	animation_tree["parameters/playback"].travel("Fade")
	delete_after_animation = true
