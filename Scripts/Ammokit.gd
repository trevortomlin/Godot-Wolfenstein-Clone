extends Sprite3D

func _on_Area_body_entered(body):
	if body.name == "Player":
		Event.emit_signal("ammo_changed", 10)
		queue_free()
