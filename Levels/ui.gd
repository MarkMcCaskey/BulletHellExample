extends Control

@export var player_hp: float:
	get: return player_hp
	set(v):
		player_hp = v
		update_labels()

@onready var hp_label: Label = $HPLabel

func update_labels() -> void:
	hp_label.text = "HP: " + str(floor(player_hp))
