extends Spatial

signal game_over

onready var tractor = $Tractor
onready var gimble = $Gimble
onready var wheat = $Wheat/MultiMeshInstance
onready var progress = $Control/ProgressBar
onready var distance_label = $Control/Distance

func _process(delta):
	gimble.global_translation = tractor.global_translation
	if wheat.total_harvest > 0:
		tractor.track_distance = true
	progress.value = float(wheat.total_harvest)/float(wheat.multimesh.instance_count) * 100
	distance_label.text = "%0.2f m" % tractor.total_distance

	if wheat.total_harvest == wheat.multimesh.instance_count:
		tractor.track_distance = false
		emit_signal("game_over",tractor.total_distance)
