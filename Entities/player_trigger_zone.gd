class_name PlayerTriggerZone extends Node2D

@export var things_to_trigger: Array[CircularBulletSpawner]

var already_triggered: bool = false

func _on_area_2d_area_entered(_area: Area2D) -> void:
	do_trigger()

func _on_area_2d_body_entered(_body: Node2D) -> void:
	do_trigger()

func do_trigger() -> void:
	if already_triggered:
		queue_free()
		return
	already_triggered = true
	for thing_to_trigger in things_to_trigger:
		thing_to_trigger.trigger()
