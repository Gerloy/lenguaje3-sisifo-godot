extends Node

var mapas:Array[String];
var map:Node;
#var map_activado = false;
var cinematicas:Array[String];
#var cine:Node;
#var cine_activada = false;
var skybox:WorldEnvironment;
var sky_comun:CompressedTexture2D;
var sky_noche:CompressedTexture2D;

enum ESTADOS {no_empezo,
 cinematica_0, trans_1,
 corinto, trans_2,
 cinematica_1, trans_3,
 inframundo, trans_4,
 cinematica_2, trans_5,
 castigo, trans_6, 
 cinematica_3, final};

var estado:ESTADOS;
var modelo_actual:Node3D; #Por ahora

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cinematicas = [];
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
	
	estado = ESTADOS.no_empezo; # Cambiar cuando este hecho el inicio
	#estado = ESTADOS.trans_5;
	map = load(cinematicas[0]).instantiate();
	get_node("/root/Prueba").add_child(map);
	skybox.environment.sky.sky_material.panorama = sky_noche;
	
	#get_node("/root/CharacterBody3D").transform.rota
	pass


func _process(_delta: float) -> void:
	match estado:
		ESTADOS.no_empezo: # Esto lo tengo que cambiar cuando toque
			if map:
				map.queue_free();
			map = load(cinematicas[0]).instantiate();
			get_node("/root/Prueba").add_child(map);
			skybox.environment.sky.sky_material.panorama = sky_noche;
			#map = load(mapas[0]).instantiate();
			#get_node("/root/Prueba").add_child(map);
			#skybox.environment.sky.sky_material.panorama = sky_comun;
			cambiarEstado();
		ESTADOS.trans_1:
			map.queue_free();
			map = load(mapas[0]).instantiate();
			get_node("/root/Prueba").add_child(map);
			skybox.environment.sky.sky_material.panorama = sky_comun;
			cambiarEstado();
		ESTADOS.trans_2:
			map.queue_free();
			map = load(cinematicas[1]).instantiate();
			get_node("/root/Prueba").add_child(map);
			skybox.environment.sky.sky_material.panorama = sky_noche;
			cambiarEstado();
		ESTADOS.trans_3:
			map.queue_free();
			map = load(mapas[1]).instantiate();
			get_node("/root/Prueba").add_child(map);
			skybox.environment.sky.sky_material.panorama = sky_comun;
			cambiarEstado();
		ESTADOS.trans_4:
			map.queue_free();
			map = load(cinematicas[2]).instantiate();
			get_node("/root/Prueba").add_child(map);
			skybox.environment.sky.sky_material.panorama = sky_noche;
			cambiarEstado();
		ESTADOS.trans_5:
			map.queue_free();
			map = load(mapas[2]).instantiate();
			get_node("/root/Prueba").add_child(map);
			skybox.environment.sky.sky_material.panorama = sky_comun;
			cambiarEstado();
		ESTADOS.trans_6:
			map.queue_free();
			map = load(cinematicas[3]).instantiate();
			get_node("/root/Prueba").add_child(map);
			skybox.environment.sky.sky_material.panorama = sky_noche;
			cambiarEstado();
		ESTADOS.final:
			map.queue_free();
			cambiarEstado();
	pass

func cambiarACinematica():
	pass
func cambiarEstado():
	print("Cambio estado");
	match estado:
		ESTADOS.no_empezo:
			estado = ESTADOS.cinematica_0;
		ESTADOS.cinematica_0:
			estado = ESTADOS.trans_1;
		ESTADOS.trans_1:
			estado = ESTADOS.corinto;
		ESTADOS.corinto:
			estado = ESTADOS.trans_2;
		ESTADOS.trans_2:
			estado = ESTADOS.cinematica_1;
		ESTADOS.cinematica_1:
			estado = ESTADOS.trans_3;
		ESTADOS.trans_3:
			estado = ESTADOS.inframundo;
		ESTADOS.inframundo:
			estado = ESTADOS.trans_4;
		ESTADOS.trans_4:
			estado = ESTADOS.cinematica_2;
		ESTADOS.cinematica_2:
			estado = ESTADOS.trans_5;
		ESTADOS.trans_5:
			estado = ESTADOS.castigo;
			get_node("/root/Prueba/Final_Piedra").set_visible(true);
			get_node("/root/Prueba/Final_Piedra/Roquita").set_position(get_node("/root/Prueba/Final_Piedra/Roquita").pos_base);
			#get_node("/root/Prueba/Final_Piedra/Roquita").prendida = true;
		ESTADOS.castigo:
			estado = ESTADOS.trans_6;
			get_node("/root/Prueba/Final_Piedra").set_visible(false);
			get_node("/root/Prueba/Final_Piedra/Roquita").prendida = false;
		ESTADOS.trans_6:
			estado = ESTADOS.cinematica_3;
		ESTADOS.cinematica_3:
			estado = ESTADOS.final;
		ESTADOS.final:
			estado = ESTADOS.no_empezo;
			#get_tree().reload_current_scene();

func moverPiedra(_val:int):
	get_node("/root/Prueba/Final_Piedra/Roquita").prendida = _val;
	pass
