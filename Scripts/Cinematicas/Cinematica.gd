extends Node

@export var nombre:String;
@export var imgs:Array[String];
@export var tiempos_imagenes:Array[float];
var index_imgs:int = 0;
@export var nombre_audios:Array[String];
var audios;
var index_audios:int = 0;
@export var tiempos_inicio_audios:Array[float];
#@export var tiempos_imagenes:Array[float];
var texturas;
var t_img;
var t;
var t_total;
var i:int;
@onready var mesh = $Mesh;
#@onready var audios = $Audios.get_children();
@onready var audio_zeus = $Audios/AudioZeus;
@onready var audio_thanatos = $Audios/AudioThanatos;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	texturas = [];
	for img in imgs:
		texturas.append(load("res://Images/cinematicas/"+nombre+"/"+img+".png"));
	audios = [];
	for audio in nombre_audios:
		audios.append($Audios.get_node(audio));
	
	#texturas.append(load("res://Images/cinematicas/cinematica 0/00.png"));
	#texturas.append(load("res://Images/cinematicas/cinematica 0/01.png"));
	#texturas.append(load("res://Images/cinematicas/cinematica 0/02.png"));
	#texturas.append(load("res://Images/cinematicas/cinematica 0/03.png"));
	
	i = 0;
	t_img = 7;
	t = 0;
	t_total = 0;
	#audio_zeus.play();
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if (index_imgs < texturas.size()) and (t >= tiempos_imagenes[index_imgs]):
		index_imgs += 1;
		t = 0;
		if index_imgs < texturas.size():
			mesh.get_surface_override_material(0).albedo_texture = texturas[index_imgs];
		else:
			Globales.cambiarEstado();
	#if t_total >= 4:
	#	audio_zeus.play();
	#if t_total >= 19 and !audio_thanatos.playing:
	#	audio_thanatos.play();
	if (index_audios < tiempos_inicio_audios.size()) and (t_total >= tiempos_inicio_audios[index_audios]):
		if !audios[index_audios].playing:
			audios[index_audios].play();
			index_audios += 1;
	t += _delta;
	t_total += _delta;
	pass
