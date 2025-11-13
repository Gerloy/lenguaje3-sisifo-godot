extends Node

var mapas:Array[String];
var map:Node;
var map_activado = false;
var cinematicas:Array[String];
var cine;
var cine_activada = false;

var estado:int = 0;
@export var modelo_actual:Node3D; #Por ahora

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mapas = [];
	mapas.append("res://modelo/corinto.tscn");
	mapas.append("res://modelo/inframundo.tscn");
	mapas.append("res://modelo/castigo.tscn");
	map_activado = true;
	#var map_scn:PackedScene = load(mapas[0]);
	map = load(mapas[0]).instantiate();
	get_node("/root/Prueba").add_child(map);
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func cambiarACinematica():
	pass
func cambiarEstado():
	estado+=1;
	map.queue_free();
	map = load(mapas[estado]).instantiate();
	get_node("/root/Prueba").add_child(map);
	#if map_activado:
	#	map_activado = false;
	#	map = load(mapas[floor(estado*0.5)]).instance();
func moverPiedra():
	pass
