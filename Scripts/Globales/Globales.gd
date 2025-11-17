extends Node

var mapas:Array[String];
var map:Node;
var map_activado = false;
var cinematicas:Array[String];
var cine;
var cine_activada = false;

enum ESTADOS {cinematica_0, trans_1, corinto, trans_2, cinematica_1, trans_3, inframundo, trans_4, cinematica_2, castigo,  trans_5, final};

var estado:int = 0;
@export var modelo_actual:Node3D; #Por ahora

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mapas = [];
	mapas.append("res://modelo/corinto.tscn");
	mapas.append("res://modelo/inframundo.tscn");
	mapas.append("res://modelo/castigo.tscn");
	map_activado = true;
	#map = load(mapas[0]).instantiate();
	#get_node("/root/Prueba").add_child(map);
	pass


func _process(_delta: float) -> void:
	pass

func cambiarACinematica():
	pass
func cambiarEstado():
	estado+=1;
	map.queue_free();
	cine.queue_free();
	map = load(mapas[estado]).instantiate();
	get_node("/root/Prueba").add_child(map);
	#if map_activado:
	#	map_activado = false;
	#	map = load(mapas[floor(estado*0.5)]).instance();
func moverPiedra():
	pass
