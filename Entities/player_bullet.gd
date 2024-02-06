extends Node2D

@export var damage: float = 10.0
@export var speed: Vector2 = Vector2(5, -160.0)
@onready var hit_area: Area2D = $Area2D
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
		call_deferred("process_boss_hit", parent)
	else:
		queue_free()
		#animation_tree["parameters/playback"].travel("Hit")
		#delete_after_animation = true


func _on_area_2d_body_entered(_body: Node2D) -> void:
	queue_free()

func process_boss_hit(boss: Boss) -> void:
	# TODO: clean this up
	boss.health -= damage
	var particles = CPUParticles2D.new()
	particles.amount = 24
	particles.color = Color(255, 0, 0)
	particles.one_shot = true
	particles.scale_amount_min = 7
	particles.tangential_accel_min = 50
	particles.orbit_velocity_min = 0.1
	particles.orbit_velocity_max = 1
	particles.spread = 90
	particles.explosiveness = 0.5
	particles.emitting = true
	boss.add_child(particles)
	hide()
	hit_area.monitorable = false
	hit_area.monitoring = false
	await get_tree().create_timer(5).timeout
	if is_instance_valid(boss):
		boss.remove_child(particles)
	queue_free()
