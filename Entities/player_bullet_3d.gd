extends Node3D

@export var damage: float = 10.0
@export var speed: Vector3 = Vector3(0, 0, 160.0)
@onready var hit_area: Area3D = $Area3D
#@export var rotation: float = 0

const blood_particles: PackedScene = preload("res://Entities/blood_particles_3d.tscn") 

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

func _on_area_3d_area_entered(area: Area3D) -> void:
	var parent = area.get_parent()
	if parent is Boss3D:
		call_deferred("process_boss_hit", parent)
	else:
		queue_free()
		#animation_tree["parameters/playback"].travel("Hit")
		#delete_after_animation = true

func _on_area_3d_body_entered(_body: Node3D) -> void:
	queue_free()

func process_boss_hit(boss: Boss3D) -> void:
	# TODO: clean this up
	boss.health -= damage
	var particles = blood_particles.instantiate()
	boss.add_child(particles)
	particles.global_position = global_position
	#particles.global_position /= 2
	particles.emitting = true
	hide()
	hit_area.monitorable = false
	hit_area.monitoring = false
	await get_tree().create_timer(5).timeout
	if is_instance_valid(boss):
		boss.remove_child(particles)
	queue_free()

func _on_timer_timeout() -> void:
	queue_free()
