extends Node

@export var cinematica_control: Node3D

func _process(_delta: float) -> void:
	if Input.is_physical_key_pressed(KEY_SPACE):
		if cinematica_control:
			cinematica_control.activar()
			print("🎥 Cinemática iniciada desde ControladorCinematica.gd")
