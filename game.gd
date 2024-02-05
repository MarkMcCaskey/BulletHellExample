extends Node2D

@onready var player: Player = $Player
@onready var ui = $CanvasLayer/UI


func _on_player_player_health_changed(_old: float, new: float) -> void:
	ui.player_hp = new
	if new <= 0:
		ui.player_lose()

func _on_boss_boss_died() -> void:
	ui.player_win()
