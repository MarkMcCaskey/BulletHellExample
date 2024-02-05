extends Control

@export var player_hp: float:
	get: return player_hp
	set(v):
		player_hp = v
		update_labels()

@onready var hp_label: Label = $HPLabel
@onready var game_state_label: Label = $GameStateLabel

func _ready() -> void:
	game_state_label.hide()

func update_labels() -> void:
	hp_label.text = "HP: " + str(floor(player_hp))

func player_win() -> void:
	game_state_label.show()
	game_state_label.text = "You Win!"

func player_lose() -> void:
	game_state_label.show()
	game_state_label.text = "You Lose!"
