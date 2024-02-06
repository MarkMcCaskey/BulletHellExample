extends Node2D

@export var damage: float = 10.0
@export var speed: Vector2 = Vector2(5, -160.0)
#@export var rotation: float = 0

#@onready var delete_after_animation: bool = false
#@onready var animation_tree: AnimationTree = $AnimationTree

func _ready() -> void:
	pass
	#animation_tree.active = true
	#animation_tree["parameters/playback"].travel("Spawn")
	#apply_impulse(Vector2(), Vector2(speed, 0).rotated(rotation))

func _physics_process(delta: float) -> void:
	global_position += speed * delta
	#debug_label.text = animation_tree.animat

func _on_area_2d_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent is Boss:
		# TODO: clean this up
		parent.health -= damage
	queue_free()
		#animation_tree["parameters/playback"].travel("Hit")
		#delete_after_animation = true


func _on_area_2d_body_entered(_body: Node2D) -> void:
	queue_free()
