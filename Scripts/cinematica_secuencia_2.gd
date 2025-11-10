extends Node3D

@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var audio: AudioStreamPlayer3D = $AudioStreamPlayer3D

@export var duracion_aparecer: float = 2.5
@export var delay_antes: float = 0.5
@export var amplitud: float = 0.15
@export var velocidad: float = 0.5

var activar_cinematica: bool = false
var apareciendo: bool = false
var tiempo: float = 0.0
var posicion_inicial: Vector3


func _ready() -> void:
	posicion_inicial = mesh.global_position
	
	# Asegurar material duplicado y comienzo transparente
	mesh.material_override = mesh.get_active_material(0).duplicate()
	var material = mesh.material_override
	if material and material is StandardMaterial3D:
		material.albedo_color.a = 0.0  # invisible al inicio

	if audio.stream:
		audio.stream.loop = false


func activar() -> void:
	if not activar_cinematica:
		activar_cinematica = true
		aparecer_con_delay()


func aparecer_con_delay() -> void:
	await get_tree().create_timer(delay_antes).timeout
	aparecer_mesh()


func aparecer_mesh() -> void:
	print("✨ Iniciando fade-in de la segunda cinematica...")
	apareciendo = true
	
	var material = mesh.material_override
	if material and material is StandardMaterial3D:
		var tween = create_tween()
		tween.tween_property(material, "albedo_color:a", 1.0, duracion_aparecer)\
			.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	audio.play()


func _process(delta: float) -> void:
	if apareciendo:
		tiempo += delta * velocidad
		var desplazamiento_y = sin(tiempo) * amplitud
		mesh.global_position = posicion_inicial + Vector3(0, desplazamiento_y, 0)
