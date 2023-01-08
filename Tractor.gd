extends KinematicBody

onready var speed = 0
export(float) var accel = 4
export(float) var max_speed = 6
export(float) var turn_speed = 1.0
var target = Vector3()
var camera
var track_distance = false
var total_distance = 0
var last_position
onready var audio = $AudioStreamPlayer
var enabled = false
onready var thresher_spinner = $Area/tractor_parts/Thresher/Spinner
onready var tractor_engine = $tractor/body
onready var particles = $Area/tractor_parts/CPUParticles
var harvest_particles_timeout = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	speed = 0
	target = Vector3(0,0,0)
	camera = get_viewport().get_camera()	
	track_distance = false
	total_distance = 0
	last_position = global_translation
	audio.play()
	enabled = true
	harvest_particles_timeout = 0
	particles.emitting = false

func _physics_process(delta):		
	var forward = global_transform.basis.z
	var to_target = target - global_translation
	var a = forward.signed_angle_to(to_target,Vector3.UP)
	
	if Input.is_action_pressed("drive") and enabled:
		speed = min(speed+accel*delta,max_speed)
		if a < 0:
			rotation.y += turn_speed * delta
		else:
			rotation.y -= turn_speed * delta
	else:
		speed = max(0,speed-accel*delta)
	
	var velocity = forward.normalized() * -speed
	
	audio.pitch_scale =  speed/max_speed + 0.75
	
	thresher_spinner.rotation.x += delta * (speed/max_speed * -5.0)
	harvest_particles_timeout += delta
	if harvest_particles_timeout > 0.5:
		particles.emitting = false
	
	move_and_slide(velocity,Vector3.UP)
	
	if track_distance:
		total_distance += (global_translation - last_position).length()
	
	last_position = global_translation
	
func _input(event):
	if event is InputEventMouseMotion:
		var l0 = camera.project_ray_origin(event.position)
		var l = camera.project_ray_normal(event.position).normalized()
		var n = Vector3(0,1,0)
		var p0 = Vector3(0,0,0)
		var t = (p0-l0).dot(n) / l.dot(n)
		target = l0 + l * t
		$Debug.set_global_translation(target)	

func _on_Area_area_entered(area):
	if area.has_method('harvest'):
		particles.emitting = true
		harvest_particles_timeout = 0
		area.harvest()
