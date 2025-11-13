extends Node3D

# ===========================
# 🎥 CONFIGURACIÓN
# ===========================
@export var duracion_fade: float = 2.0
@export var tiempo_visible: float = 3.0
@export var amplitud: float = 0.15
@export var velocidad: float = 0.5

# 🔹 Nombre o ruta del siguiente nodo de cinemática
#@export var ruta_siguiente: NodePath = "../CinematicaSecuencia2"

# ===========================
# 🎞️ REFERENCIAS A NODOS
# ===========================
@onready var meshes := [
	$Mesh1,
	$Mesh2,
	$Mesh3
]

@onready var audios := [
	$Audio1,
	$Audio2,
	$Audio3
]

# ===========================
# ⚙️ VARIABLES DE ESTADO
# ===========================
var indice_actual: int = 0
var tiempo: float = 0.0
var posiciones_iniciales: Array = []
var activado: bool = false


# ===========================
# 🟢 INICIO
# ===========================
func _ready() -> void:
	# Guardar posiciones y hacer materiales únicos
	for mesh in meshes:
		posiciones_iniciales.append(mesh.global_position)
		mesh.material_override = mesh.get_active_material(0).duplicate()
		mesh.material_override.albedo_color.a = 0.0
		mesh.visible = false
	
	# Asegurar que los audios no hagan loop
	for audio in audios:
		if audio.stream:
			audio.stream.loop = false


# ===========================
# ⌨️ ENTRADA DE TECLADO
# ===========================
func _input(event):
	if event.is_action_pressed("ui_accept"):  # Por defecto es la barra espaciadora
		if not activado:
			print("🎬 Secuencia iniciada por barra espaciadora")
			activar()


# ===========================
# 🔄 CICLO DE ACTUALIZACIÓN
# ===========================
func _process(delta: float) -> void:
	if not activado:
		return
	
	# Movimiento suave de flotación para la imagen actual
	if indice_actual < meshes.size():
		var mesh = meshes[indice_actual]
		if mesh.visible:
			tiempo += delta * velocidad
			var desplazamiento_y = sin(tiempo) * amplitud
			mesh.global_position = posiciones_iniciales[indice_actual] + Vector3(0, desplazamiento_y, 0)


# ===========================
# ▶️ ACTIVAR SECUENCIA
# ===========================
func activar() -> void:
	if activado:
		return
	activado = true
	indice_actual = 0
	ejecutar_siguiente_imagen()


# ===========================
# 🎞️ CONTROL DE IMÁGENES
# ===========================
func ejecutar_siguiente_imagen() -> void:
	if indice_actual >= meshes.size():
		print("✅ Secuencia terminada. Activando siguiente narrativa...")
		var siguiente = get_node_or_null("../CinematicaControl_2")
		if siguiente:
			siguiente.activar()
		else:
			print("⚠️ No se encontró el nodo de la siguiente escena.")
		return
	
	var mesh = meshes[indice_actual]
	var audio = audios[indice_actual] if indice_actual < audios.size() else null
	
	print("📸 Mostrando imagen ", indice_actual + 1)
	mesh.visible = true
	
	# Fade in
	var material = mesh.material_override
	var tween_in = create_tween()
	tween_in.tween_property(material, "albedo_color:a", 1.0, duracion_fade)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	if audio:
		audio.play()
	
	# Esperar tiempo visible + fade
	await get_tree().create_timer(duracion_fade + tiempo_visible).timeout
	
	# Fade out
	var tween_out = create_tween()
	tween_out.tween_property(material, "albedo_color:a", 0.0, duracion_fade)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	await tween_out.finished
	
	mesh.visible = false
	indice_actual += 1
	tiempo = 0.0  # reiniciar flotación
	ejecutar_siguiente_imagen()
