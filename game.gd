extends Node2D

@onready var player: Player = $PlayableArea/Player
@onready var ui = $CanvasLayer/UI
@onready var playable_area: Node2D = $PlayableArea
@onready var camera: Camera2D = $Camera2D
@onready var chromatic_aberation_effect: ColorRect = $Camera2D/CanvasLayer/ColorRect

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
	var extent = ((100 - max(player.health, 0)) / 15)
	chromatic_aberation_effect.material.set_shader_parameter("r_displacement", Vector2(extent, extent / 3))
	chromatic_aberation_effect.material.set_shader_parameter("b_displacement", Vector2(extent * -1, extent / -3))
	for i in range(6):
		var x_val = randf() * camera_shake_intensity - camera_shake_intensity / 2
		var y_val = randf() * camera_shake_intensity - camera_shake_intensity / 2
		camera.offset.x = x_val
		camera.offset.y = y_val
		chromatic_aberation_effect.material.set_shader_parameter("r_displacement", Vector2(extent * y_val, (extent * x_val) / 3))
		chromatic_aberation_effect.material.set_shader_parameter("b_displacement", Vector2(extent * y_val * -1, (extent * x_val) / -3))
		await get_tree().create_timer(0.05).timeout
	chromatic_aberation_effect.material.set_shader_parameter("r_displacement", Vector2(extent, extent / 3))
	chromatic_aberation_effect.material.set_shader_parameter("b_displacement", Vector2(extent * -1, extent / -3))
