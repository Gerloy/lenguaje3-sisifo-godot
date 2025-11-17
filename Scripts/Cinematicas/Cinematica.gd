extends Node

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
	texturas.append(load("res://Images/cinematicas/cinematica 0/00.png"));
	texturas.append(load("res://Images/cinematicas/cinematica 0/01.png"));
	texturas.append(load("res://Images/cinematicas/cinematica 0/02.png"));
	texturas.append(load("res://Images/cinematicas/cinematica 0/03.png"));
	i = 0;
	t_img = 7;
	t = 0;
	t_total = 0;
	audio_zeus.play();
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if t >= t_img:
		i += 1;
		t = 0;
		if i < texturas.size():
			mesh.get_surface_override_material(0).albedo_texture = texturas[i];
		#else:
			#Globales.cambiarEstado();
	#if t_total >= 4:
	#	audio_zeus.play();
	if t_total >= 19 and !audio_thanatos.playing:
		audio_thanatos.play();
	t += _delta;
	t_total += _delta;
	pass
