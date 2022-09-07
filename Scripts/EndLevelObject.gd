extends Sprite3D


func _on_Area_body_entered(body):
	if body.name == "Player":
		LevelManager.next_level()
