class_name Model12Shotgun extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

enum ShotgunState { Ready, EmptyShellInChamber, Pumping, Shooting }

var state: ShotgunState = ShotgunState.Ready

signal ShotFinished()
signal PumpFinished()

func pump() -> void:
	if state == ShotgunState.Ready || state == ShotgunState.EmptyShellInChamber:
		animation_player.play("Pump")
		state = ShotgunState.Pumping

func shoot() -> void:
	if state != ShotgunState.Ready: return
	state = ShotgunState.Shooting
	animation_player.play("Shoot")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Pump":
		state = ShotgunState.Ready
		emit_signal("PumpFinished")
	elif anim_name == "Shoot":
		state = ShotgunState.EmptyShellInChamber
		emit_signal("ShotFinished")
