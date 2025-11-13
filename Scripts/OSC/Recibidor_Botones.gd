extends OSCReceiver

@onready var pj = get_parent();
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if target_server.incoming_messages.has(osc_address):
		#print(target_server.incoming_messages);
		if target_server.incoming_messages[osc_address][0] != 0:
			#print('Llego decision');
			if Globales.map_activado:
				Globales.cambiarEstado();
	if target_server.incoming_messages.has("/piedra"):
		Globales.moverPiedra();
		#if Globales.map_activado:
		#	Globales.cambiarEstado();
	pass
