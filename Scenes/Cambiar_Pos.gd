extends OSCReceiver

@onready var pj = get_parent();
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if target_server.incoming_messages.has(osc_address):
		#pj.transform.position = Vector3(target_server.incoming_messages.);
		pass;
	pass
