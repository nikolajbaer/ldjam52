extends Spatial

signal game_over

onready var tractor = $Tractor
onready var gimble = $Gimble
onready var wheat = $Wheat/MultiMeshInstance
onready var distance_label = $Control/Distance
onready var harvest_label = $Control/Harvest
onready var efficiency_label = $Control/Efficiency
onready var treads = $TractorTreads
onready var fps_label = $Control/Framerate
var tread_counter
var TREAD_FACTOR = 0.1
var harvest_time

func _ready():
	tread_counter = 0
	harvest_time = 0

func _process(delta):
	gimble.global_translation = tractor.global_translation
	if wheat.total_harvest > 0:
		tractor.track_distance = true
	
	harvest_label.text = "%s of %s in %s sec" % [wheat.total_harvest,wheat.multimesh.instance_count,floor(harvest_time)]
	distance_label.text = "%0.2f m" % tractor.total_distance
	var efficiency = null
	if float(wheat.total_harvest)/wheat.multimesh.instance_count > 0.1:
		efficiency = float(wheat.total_harvest)/(tractor.total_distance)
		efficiency_label.text = "%0.1f wheat/m" % (efficiency)
	else:
		efficiency_label.text = " - "

	if tractor.enabled:
		harvest_time += delta
		
	if wheat.total_harvest >= wheat.multimesh.instance_count:
		tractor.track_distance = false
		tractor.enabled = false
		# more efficient, higher score, with time penjalty
		var score = (efficiency + (1.0/harvest_time * 100.0)) * 100.0
		$Menu/GameOver.visible = true
		$Menu/GameOver.text = "GAME OVER\n SCORE: efficiency + time bonus = %0.0f" % score
		emit_signal("game_over",tractor.total_distance,harvest_time)
	
	if tractor.speed > 0:
		tread_counter += delta
		if tread_counter > TREAD_FACTOR:
			treads.leave_track(tractor.global_translation,tractor.rotation.y)
			tread_counter = 0
			
	fps_label.set_text(str(Engine.get_frames_per_second()))

func _on_Spatial_tree_exiting():
	$AudioStreamPlayer.stop()
