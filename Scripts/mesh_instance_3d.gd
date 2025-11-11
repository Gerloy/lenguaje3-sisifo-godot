extends MeshInstance3D

@onready var video_player = $"../VideoStreamPlayer"

func _process(delta):
	if video_player.get_video_texture():
		var mat = self.get_active_material(0)
		if mat:
			mat.albedo_texture = video_player.get_video_texture()
