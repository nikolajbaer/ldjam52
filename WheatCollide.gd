extends Area

signal harvested

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func harvest():
	emit_signal('harvested')
