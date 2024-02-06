extends Node2D

@onready var player: Player = $PlayableArea/Player
@onready var ui = $CanvasLayer/UI
@onready var playable_area: Node2D = $PlayableArea

@export var scroll_speed: float = 40.0

func _physics_process(delta: float) -> void:
	playable_area.global_translate(Vector2(0, scroll_speed * delta * -1))
	#playable_area.position.y -= scroll_speed * delta 

func _on_player_player_health_changed(_old: float, new: float) -> void:
	ui.player_hp = new
	if new <= 0:
		ui.player_lose()

func _on_boss_boss_died() -> void:
	ui.player_win()
