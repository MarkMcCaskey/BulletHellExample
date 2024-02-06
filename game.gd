extends Node2D

@onready var player: Player = $PlayableArea/Player
@onready var ui = $CanvasLayer/UI
@onready var playable_area: Node2D = $PlayableArea
@onready var camera: Camera2D = $Camera2D

@export var scroll_speed: float = 60.0

func _physics_process(delta: float) -> void:
	playable_area.global_translate(Vector2(0, scroll_speed * delta * -1))
	#playable_area.position.y -= scroll_speed * delta 

func _on_player_player_health_changed(old: float, new: float) -> void:
	ui.player_hp = new
	if old > new:
		player_damage_taken()
	if new <= 0:
		ui.player_lose()
		player.die()

func _on_boss_boss_died() -> void:
	ui.player_win()

var camera_shake_intensity: float = 10.0

func player_damage_taken() -> void:
	for i in range(6):
		camera.offset.x = randf() * camera_shake_intensity - camera_shake_intensity / 2
		camera.offset.y = randf() * camera_shake_intensity - camera_shake_intensity / 2
		await get_tree().create_timer(0.05).timeout
