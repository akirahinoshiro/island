extends DirectionalLight

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _setDirection(player):
	#var to_player_local = global_transform.xform_inv(player.global_transform.origin)
	#var angle_to_player = atan2(to_player_local.x, to_player_local.z)
	look_at(player.global_transform.origin, Vector3(0, 1, 0))
