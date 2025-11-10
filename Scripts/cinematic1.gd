extends Node3D

# 🔹 Referencias a los nodos hijos
@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var audio1: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var audio2: AudioStreamPlayer3D = $AudioStreamPlayer3D_2  # segundo audio opcional

# 🔹 Control de activación
var activar_cinematica: bool = false
var audio_reproducido: bool = false
var desvaneciendo: bool = false

# 🔹 Parámetros del movimiento
@export var velocidad: float = 0.5
@export var amplitud: float = 0.2

# 🔹 Delay de cada audio
@export var delay_audio1: float = 2.0
@export var delay_audio2: float = 4.0

# 🔹 Tiempo antes de desaparecer y duración del fade
@export var delay_desvanecer: float = 8.0
@export var duracion_desvanecer: float = 2.5

# 🔹 Variables internas
var tiempo: float = 0.0
var posicion_inicial: Vector3


func _ready() -> void:
	posicion_inicial = mesh.global_position
	
	# Asegurar que los audios no hagan loop
	if audio1.stream:
		audio1.stream.loop = false
	if audio2.stream:
		audio2.stream.loop = false

	# Asegurar que el material del mesh sea único (para no afectar otros objetos)
	mesh.material_override = mesh.get_active_material(0).duplicate()


func activar() -> void:
	activar_cinematica = true


func _process(delta: float) -> void:
	if activar_cinematica and not audio_reproducido:
		audio_reproducido = true
		iniciar_cinematica()

	# 🔹 Movimiento tipo flotación
	if activar_cinematica and not desvaneciendo:
		tiempo += delta * velocidad
		var desplazamiento_y = sin(tiempo) * amplitud
		mesh.global_position = posicion_inicial + Vector3(0, desplazamiento_y, 0)
	else:
		mesh.global_position = posicion_inicial


func iniciar_cinematica() -> void:
	print("🎬 Cinemática activada")
	
	# Reproducir audios con delay
	reproducir_audio_con_delay(audio1, delay_audio1)
	reproducir_audio_con_delay(audio2, delay_audio2)
	
	# Iniciar desvanecimiento luego del tiempo establecido
	iniciar_desvanecer_con_delay()


func reproducir_audio_con_delay(audio_player: AudioStreamPlayer3D, delay: float) -> void:
	if delay > 0:
		await get_tree().create_timer(delay).timeout
	audio_player.play()


func iniciar_desvanecer_con_delay() -> void:
	await get_tree().create_timer(delay_desvanecer).timeout
	desvanecer_mesh()


func desvanecer_mesh() -> void:
	desvaneciendo = true
	print("🌫️ Iniciando desvanecimiento del mesh...")

	var material = mesh.material_override
	if material and material is StandardMaterial3D:
		var tween = create_tween()
		tween.tween_property(material, "albedo_color:a", 0.0, duracion_desvanecer)\
			.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		
		# 🔹 Conectar el evento terminado al método externo
		tween.finished.connect(_on_tween_finished)

func _on_tween_finished() -> void:
	mesh.visible = false
	print("✅ Mesh completamente desvanecido")

	# Llamar a la siguiente cinemática (fade-in)
	var siguiente = get_node("../CinematicaControl_2")  # ajustá la ruta según tu escena
	if siguiente:
		siguiente.activar()


			
