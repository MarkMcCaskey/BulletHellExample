class_name CircularBulletSpawner extends Node2D

@export var num_bullets: int = 16

var bullet: PackedScene = preload("res://Entities/bullet.tscn")

func _ready() -> void:
	#call_deferred("trigger")
	pass
	#trigger()

func trigger() -> void:
	var degree_sep = 360.0 / float(num_bullets)
	for i in range(num_bullets):
		var scene = bullet.instantiate()
		var direction = degree_sep * float(i)
		scene.speed = Vector2(1, 1).rotated(deg_to_rad(direction)) * 100
		scene.global_position = global_position
		#print("Bullet going to " + str(scene.speed))
		call_deferred("add_deferred", get_parent().get_parent(), scene)
		#get_parent().get_parent().add_child(scene)

func add_deferred(parent: Node, scene: Bullet) -> void:
	parent.add_child(scene)
