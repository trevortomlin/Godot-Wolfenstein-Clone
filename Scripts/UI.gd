extends Control

onready var health_label = $"Health/Health Label"
onready var ammo_label = $"Ammo/Ammo Label"

func _ready():
	Event.connect("set_health", self, "set_health")
	Event.connect("set_ammo", self, "set_ammo")
	Event.connect("health_changed", self, "change_health")
	Event.connect("ammo_changed", self, "change_ammo")

func set_health(val):
	health_label.text = str(val)
	
func set_ammo(val):
	ammo_label.text = str(val)

func change_health(val):
	var v = int(health_label.text) + val
	v = clamp(v, 0, 100)
	health_label.text = str(v)
		
	
func change_ammo(val):
	ammo_label.text = str(int(ammo_label.text) + val)
