extends Spatial

onready var tractor = $Tractor
onready var wheat = $Wheat
var harvested = 0

func _ready():
	harvested = 0

func _process(delta):
	harvested += wheat.harvest(tractor.global_translation)	
