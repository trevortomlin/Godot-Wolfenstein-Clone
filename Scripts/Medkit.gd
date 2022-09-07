extends Sprite3D

func _on_Area_body_entered(body):
	if body.name == "Player":
		var ref = funcref(self, 'increase_health')
		Event.emit_signal("pickup_medkit", self, ref)
	
func increase_health():
	Event.emit_signal("health_changed", 25)
	queue_free()
