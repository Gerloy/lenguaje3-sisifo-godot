extends MeshInstance3D

@export var fin:Node3D;
@export var vel:float;
@export var rad:float;
@export var pj:CharacterBody3D;
@export var pos_base:Vector3;
var prendida:bool;
var ascenso:bool;

var dir:Vector3;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	prendida = false;
	ascenso = true;
	pos_base = get_position();
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if prendida:
		if ascenso:
			dir = (fin.get_position() - get_position()).normalized();
			var mov = dir*vel;
			set_position(get_position()+mov);
			pj.set_position(pj.get_position()+mov);
			if get_position().distance_to(fin.position) <= rad:
				ascenso = false;
				#Globales.cambiarEstado();
				#prendida = false;
		else:
			dir = (pos_base - get_position()).normalized();
			var mov = dir*vel;
			set_position(get_position()+mov);
			pj.set_position(pj.get_position()+mov);
			if get_position().distance_to(pos_base) <= rad:
				prendida = false;
				Globales.cambiarEstado();
				#print("Termino");
				#prendida = false;
	else:
		if get_position().distance_to(pos_base) > rad:
			dir = (pos_base - get_position()).normalized();
			var mov = dir*vel;
			set_position(get_position()+mov);
			pj.set_position(pj.get_position()+mov);
			
	pass
