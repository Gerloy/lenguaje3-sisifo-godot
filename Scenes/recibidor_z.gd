extends OSCReceiver

@onready var pj = get_parent();
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(target_server.incoming_messages);
	if target_server.incoming_messages.has(osc_address):
		#print(target_server.incoming_messages);
		pj.global_position = Vector3(pj.global_position.x,pj.global_position.y,target_server.incoming_messages[osc_address][0]);
	#	pass;
	pass
	pass
