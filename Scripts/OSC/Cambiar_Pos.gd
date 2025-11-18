extends OSCReceiver

@onready var pj = get_parent();
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if target_server.incoming_messages.has(osc_address):
		pj.position = Vector3(target_server.incoming_messages[osc_address][0],pj.position.y,pj.position.z);
	#	pass;
	pass
