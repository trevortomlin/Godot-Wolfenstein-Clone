extends Node

var level = -1

func next_level():
	level += 1
	var level_str := "res://Scenes//Level" + str(level) + ".tscn"
	get_tree().change_scene(level_str)
