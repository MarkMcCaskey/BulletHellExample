extends Node3D

@onready var player: Player3D = $PlayableArea/Player3D
@onready var playable_area: Node3D = $PlayableArea

@export var scroll_speed: float = 60.0

func _physics_process(delta: float) -> void:
	playable_area.global_translate(Vector3(0, 0, scroll_speed * delta * -1))
	#playable_area.position.y -= scroll_speed * delta 

func _on_boss_3d_boss_died() -> void:
	player.player_win()
