extends Spatial

onready var tractor = $Tractor
onready var wheat = $Wheat
onready var gimble = $Gimble
var harvested = 0

func _ready():
	harvested = 0

func _process(delta):
	gimble.global_translation = tractor.global_translation
