extends Area

signal harvested

func _ready():
	monitoring = false

func harvest():
	monitorable = false
	emit_signal('harvested')
