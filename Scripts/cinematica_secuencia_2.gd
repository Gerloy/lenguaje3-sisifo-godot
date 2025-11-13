extends Node3D

@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var audio: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var audio2: AudioStreamPlayer3D = $AudioStreamPlayer3D2
@onready var audio3: AudioStreamPlayer3D = $AudioStreamPlayer3D3
@onready var audio4: AudioStreamPlayer3D = $AudioStreamPlayer3D4

@export var duracion_aparecer: float = 2.5
@export var delay_antes: float = 0.5
@export var amplitud: float = 0.15
@export var velocidad: float = 0.5
@export var tiempo_ocultar: float = 3.0  # tiempo de fade-out antes de cambiar de escena

var activar_cinematica: bool = false
var apareciendo: bool = false
var tiempo: float = 0.0
var posicion_inicial: Vector3


func _ready() -> void:
	posicion_inicial = mesh.global_position

	# Duplicar material y asegurarse que sea transparente
	mesh.material_override = mesh.get_active_material(0).duplicate()
	var material = mesh.material_override
	if material and material is StandardMaterial3D:
		material.albedo_color.a = 0.0
		material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		material.blend_mode = BaseMaterial3D.BLEND_MODE_MIX

	# Evitar loops en los audios
	for a in [audio, audio2, audio3, audio4]:
		if a.stream:
			a.stream.loop = false


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

	# Reproducir todos los audios
	audio.play()
	audio2.play()
	audio3.play()
	audio4.play()

	# Esperar a que termine el último audio para iniciar fade-out
	await get_tree().create_timer( max(audio4.stream.get_length(), 4.0) ).timeout
	ocultar_mesh_y_cambiar()


func ocultar_mesh_y_cambiar() -> void:
	print("🌑 Ocultando mesh antes de cambiar de escena...")
	var material = mesh.material_override
	if material and material is StandardMaterial3D:
		var tween = create_tween()
		tween.tween_property(material, "albedo_color:a", 0.0, tiempo_ocultar)\
			.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tween.finished.connect(_on_fade_out_finished)


func _on_fade_out_finished() -> void:
	mesh.visible = false
	#print("➡️ Pasando a la siguiente cinemática (final)...")

	var siguiente = get_node_or_null("../CinematicaSecuenciaFinal1")
	#if siguiente and siguiente.has_method("ejecutar_siguiente"):
	siguiente.ejecutar_siguiente()
	apareciendo = false;
	#else:
	#	print("⚠ No se encontró la siguiente escena.")


func _process(delta: float) -> void:
	if apareciendo:
		tiempo += delta * velocidad
		var desplazamiento_y = sin(tiempo) * amplitud
		mesh.global_position = posicion_inicial + Vector3(0, desplazamiento_y, 0)

		
		
