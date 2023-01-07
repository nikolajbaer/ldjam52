extends KinematicBody

onready var speed = 0
export(float) var accel = 7
export(float) var max_speed = 15
export(float) var turn_speed = 0.5
var target = Vector3()
onready var camera = $Camera

# Called when the node enters the scene tree for the first time.
func _ready():
	speed = 0
	target = Vector3(0,0,0)

func _physics_process(delta):		
	var forward = global_transform.basis.z
	var to_target = target - global_translation
	var a = forward.signed_angle_to(to_target,Vector3.UP)
	
	if Input.is_action_pressed("drive"):

		speed = min(speed+accel*delta,max_speed)
		if a < 0:
			rotation.y += turn_speed * delta
		else:
			rotation.y -= turn_speed * delta
	else:
		speed = max(0,speed-accel*delta)
	
	var velocity = forward.normalized() * -speed
	move_and_slide(velocity*delta,Vector3.UP)
	

func _input(event):
	if event is InputEventMouseMotion:
		var l0 = camera.project_ray_origin(event.position)
		var l = camera.project_ray_normal(event.position).normalized()
		var n = Vector3(0,1,0)
		var p0 = Vector3(0,0,0)
		var t = (p0-l0).dot(n) / l.dot(n)
		target = l0 + l * t
		$Debug.set_global_translation(target)
		

