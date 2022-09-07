extends KinematicBody

const MOVE_SPEED = 8
const MOUSE_SENS = 0.2

onready var anim_player := $AnimationPlayer
onready var raycast = $RayCast
onready var b_decal = preload("res://Scenes//BulletDecal.tscn")

onready var camera := $Camera
onready var original_camera_translation: Vector3 = camera.translation

onready var i_frame_timer := $"I Frames"

var health := 100
var ammo := 15

var can_take_damage = true

var cumdelta := 0.0

var spawn_loc = null

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	yield(get_tree(), "idle_frame")
	get_tree().call_group("zombies", "set_player", self)
	
	Event.emit_signal("set_ammo", ammo)
	Event.emit_signal("set_health", health)	
	
	Event.connect("spawn_player", self, "spawn")
	
	Event.connect("health_changed", self, "health_changed")
	Event.connect("ammo_changed", self, "ammo_changed")
	
	Event.connect("pickup_medkit", self, "pickup_health")
	
func pickup_health(obj, meth):
	if health == 100:
		return 
	else:
		meth.call_func()

	
func health_changed(val):
	health += val
	health = clamp(health, 0, 100)

func ammo_changed(val):
	ammo += val	
	ammo = clamp(ammo, 0, 15)	

func spawn(loc):
	spawn_loc = loc
	self.translation = loc
	
func _input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= MOUSE_SENS * event.relative.x

func _process(delta):
	if Input.is_action_pressed("exit"):
		get_tree().quit()

func _physics_process(delta):
	
	cumdelta += delta
	if cumdelta > 10:
		cumdelta = 0
	
	var move_vec = Vector3()
	
	if Input.is_action_pressed("move_forwards"):
		move_vec.z -= 1
	if Input.is_action_pressed("move_backwards"):
		move_vec.z += 1
	if Input.is_action_pressed("move_left"):
		move_vec.x -= 1
	if Input.is_action_pressed("move_right"):
		move_vec.x += 1
	
	move_vec = move_vec.normalized()
	move_vec = move_vec.rotated(Vector3(0, 1, 0), rotation.y)
	move_and_collide(move_vec * MOVE_SPEED * delta)
	
	var camera_bob = floor(abs(move_vec.x) + abs(move_vec.z)) * cumdelta * 15
	var target_camera_translation := original_camera_translation + Vector3.UP * sin(camera_bob) * 0.5
	camera.translation = camera.translation.linear_interpolate(target_camera_translation, delta)
	
	if Input.is_action_pressed("shoot") and !anim_player.is_playing():
		if ammo > 0:
			ammo -= 1
			anim_player.play("Shoot")
			Event.emit_signal("set_ammo", ammo)
			var coll = raycast.get_collider()
			if raycast.is_colliding() and coll.has_method("kill"):
				coll.kill()
			else:
				var b = b_decal.instance()
				coll.add_child(b)
				b.global_transform.origin = raycast.get_collision_point()
				b.look_at(raycast.get_collision_point() + raycast.get_collision_normal(), Vector3.UP)
		
func take_damage(val):

	if not can_take_damage:
		return
	
	if health - val <= 0:
		Event.emit_signal("set_health", 0)
		kill()
	else:
		health -= val
		Event.emit_signal("set_health", health)	
		can_take_damage = false
		i_frame_timer.start()
			
func kill():
	get_tree().reload_current_scene()


func _on_I_Frames_timeout():
	can_take_damage = true
