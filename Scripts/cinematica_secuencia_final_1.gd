extends Node3D

@export var imagenes: Array[MeshInstance3D]
@export var audios: Array[AudioStreamPlayer3D]
@export var duracion_fade := 2.0
@export var amplitud_flotacion := 0.1
@export var velocidad_flotacion := 1.5
@export var siguiente_escena: NodePath

var indice_actual := 0
var activo := false
var tiempo := 0.0

func _ready():
	for mesh in imagenes:
		mesh.visible = false
		# Si no tiene material override, lo creamos y lo configuramos transparente
		if mesh.material_override == null:
			mesh.material_override = StandardMaterial3D.new()
			mesh.material_override.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
			mesh.material_override.albedo_color = Color(1, 1, 1, 0)
		else:
			# Aseguramos que el material sea transparente
			#mesh.material_override.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
			set_opacidad(mesh, 0.0)
	#ejecutar_siguiente();

func _process(delta):
	if activo and indice_actual < imagenes.size():
		var mesh = imagenes[indice_actual]
		tiempo += delta
		var pos = mesh.position
		pos.y = sin(tiempo * velocidad_flotacion) * amplitud_flotacion
		mesh.position = pos

func _input(event):
	if event.is_action_pressed("ui_next_cinematic") and not activo:
		print("▶ Iniciando Cinemática Final (tecla exclusiva)")
		activo = true
		ejecutar_siguiente()


func ejecutar_siguiente():
	if indice_actual >= imagenes.size():
		print("✅ Cinemática final completada. Pasando a siguiente escena.")
		if siguiente_escena:
			var siguiente = get_node_or_null(siguiente_escena)
			if siguiente and siguiente.has_method("activar"):
				siguiente.activar()
		return

	var mesh = imagenes[indice_actual]
	var audio = audios[indice_actual]

	mesh.visible = true
	set_opacidad(mesh, 0.0)

	# Fade in de imagen
	var tween_in = create_tween()
	tween_in.tween_property(mesh.material_override, "albedo_color:a", 1.0, duracion_fade)
	print("🎬 Mostrando imagen ", indice_actual + 1)

	# Reproducir audio si existe
	if audio:
		audio.play()
		# Conectar evento cuando termine el audio
		audio.finished.connect(func():
			print("🎵 Audio terminado para imagen ", indice_actual + 1)
			fade_out_imagen(mesh)
			indice_actual += 1
			await get_tree().create_timer(0.5).timeout
			ejecutar_siguiente()
		)
	else:
		# Si no hay audio, pasamos a la siguiente luego de un tiempo corto
		await get_tree().create_timer(2.0).timeout
		fade_out_imagen(mesh)
		indice_actual += 1
		ejecutar_siguiente()

func fade_out_imagen(mesh: MeshInstance3D):
	var tween_out = create_tween()
	tween_out.tween_property(mesh.material_override, "albedo_color:a", 0.0, duracion_fade)
	tween_out.finished.connect(func():
		mesh.visible = false
		print("🌑 Imagen ", indice_actual, " desvanecida.")
	)

func set_opacidad(mesh: MeshInstance3D, alpha: float):
	if mesh.material_override:
		var color = mesh.material_override.albedo_color
		color.a = alpha
		mesh.material_override.albedo_color = color
