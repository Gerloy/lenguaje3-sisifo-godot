extends Node

var mapas:Array[String];
var map:Node;
var cinematicas:Array[String];
var skybox:WorldEnvironment;
var sky_comun:CompressedTexture2D;
var sky_noche:CompressedTexture2D;

enum ESTADOS {
	no_empezo,
	logo_facultad, trans_0,        # 👈 NUEVOS ESTADOS AGREGADOS
	cinematica_0, trans_1,
	corinto, trans_2,
	cinematica_1, trans_3,
	inframundo, trans_4,
	cinematica_2, trans_5,
	castigo, trans_6,
	cinematica_3, final
}

var estado:ESTADOS;
var modelo_actual:Node3D; #Por ahora

func _ready() -> void:
	cinematicas = [];
	cinematicas.append("res://Cinematicas/LogoFacultad.tscn");  # 👈 NUEVA CINEMÁTICA INICIAL
	cinematicas.append("res://Cinematicas/cinematica_0.tscn");
	cinematicas.append("res://Cinematicas/cinematica_1.tscn");
	cinematicas.append("res://Cinematicas/cinematica_2.tscn");
	cinematicas.append("res://Cinematicas/cinematica_3.tscn");

	mapas = [];
	mapas.append("res://modelo/corinto.tscn");
	mapas.append("res://modelo/inframundo.tscn");
	mapas.append("res://modelo/castigo.tscn");

	skybox = get_node("/root/Prueba/Entorno");
	sky_comun = load("res://Images/skybox/skybox.png");
	sky_noche = load("res://Images/skybox/Fondo Noche.png");

	estado = ESTADOS.no_empezo;

	map = load(cinematicas[0]).instantiate();   # 👈 ahora inicia cargando LogoFacultad
	get_node("/root/Prueba").add_child(map);
	skybox.environment.sky.sky_material.panorama = sky_noche;


func _process(_delta: float) -> void:
	match estado:

		ESTADOS.no_empezo:
			if map:
				map.queue_free()
			map = load(cinematicas[0]).instantiate()   # LogoFacultad
			get_node("/root/Prueba").add_child(map)
			skybox.environment.sky.sky_material.panorama = sky_noche
			cambiarEstado()

		ESTADOS.trans_0:
			map.queue_free()
			map = load(cinematicas[1]).instantiate()    # cinematica_0
			get_node("/root/Prueba").add_child(map)
			skybox.environment.sky.sky_material.panorama = sky_noche
			cambiarEstado()

		ESTADOS.trans_1:
			map.queue_free()
			map = load(mapas[0]).instantiate()
			get_node("/root/Prueba").add_child(map)
			skybox.environment.sky.sky_material.panorama = sky_comun
			cambiarEstado()

		ESTADOS.trans_2:
			map.queue_free()
			map = load(cinematicas[2]).instantiate()
			get_node("/root/Prueba").add_child(map)
			skybox.environment.sky.sky_material.panorama = sky_noche
			cambiarEstado()

		ESTADOS.trans_3:
			map.queue_free()
			map = load(mapas[1]).instantiate()
			get_node("/root/Prueba").add_child(map)
			skybox.environment.sky.sky_material.panorama = sky_comun
			cambiarEstado()

		ESTADOS.trans_4:
			map.queue_free()
			map = load(cinematicas[3]).instantiate()
			get_node("/root/Prueba").add_child(map)
			skybox.environment.sky.sky_material.panorama = sky_noche
			cambiarEstado()

		ESTADOS.trans_5:
			map.queue_free()
			map = load(mapas[2]).instantiate()
			get_node("/root/Prueba").add_child(map)
			skybox.environment.sky.sky_material.panorama = sky_comun
			cambiarEstado()

		ESTADOS.trans_6:
			map.queue_free()
			map = load(cinematicas[4]).instantiate()
			get_node("/root/Prueba").add_child(map)
			skybox.environment.sky.sky_material.panorama = sky_noche
			cambiarEstado()

		ESTADOS.final:
			map.queue_free()
			cambiarEstado()


func cambiarEstado():
	print("Cambio estado")
	match estado:

		ESTADOS.no_empezo:
			estado = ESTADOS.logo_facultad

		ESTADOS.logo_facultad:
			estado = ESTADOS.trans_0

		ESTADOS.trans_0:
			estado = ESTADOS.cinematica_0

		ESTADOS.cinematica_0:
			estado = ESTADOS.trans_1

		ESTADOS.trans_1:
			estado = ESTADOS.corinto

		ESTADOS.corinto:
			estado = ESTADOS.trans_2

		ESTADOS.trans_2:
			estado = ESTADOS.cinematica_1

		ESTADOS.cinematica_1:
			estado = ESTADOS.trans_3

		ESTADOS.trans_3:
			estado = ESTADOS.inframundo

		ESTADOS.inframundo:
			estado = ESTADOS.trans_4

		ESTADOS.trans_4:
			estado = ESTADOS.cinematica_2

		ESTADOS.cinematica_2:
			estado = ESTADOS.trans_5

		ESTADOS.trans_5:
			estado = ESTADOS.castigo
			get_node("/root/Prueba/Final_Piedra").set_visible(true)
			get_node("/root/Prueba/Final_Piedra/Roquita").set_position(
				get_node("/root/Prueba/Final_Piedra/Roquita").pos_base
			)

		ESTADOS.castigo:
			estado = ESTADOS.trans_6
			get_node("/root/Prueba/Final_Piedra").set_visible(false)
			get_node("/root/Prueba/Final_Piedra/Roquita").prendida = false

		ESTADOS.trans_6:
			estado = ESTADOS.cinematica_3

		ESTADOS.cinematica_3:
			estado = ESTADOS.final

		ESTADOS.final:
			estado = ESTADOS.no_empezo


func moverPiedra(_val:int):
	get_node("/root/Prueba/Final_Piedra/Roquita").prendida = _val
