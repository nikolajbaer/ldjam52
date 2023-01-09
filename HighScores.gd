extends Node2D

var _scores_js_callback = JavaScript.create_callback(self, "getHighScores") # This reference must be kept

func _ready():

	if OS.has_feature('JavaScript'):
		var scores = JavaScript.get_interface("scores")
		scores.getScores(_scores_js_callback)
	else:
		$PanelContainer/VBoxContainer/Scores.text = "High scores not available"
		$PanelContainer/VBoxContainer/Button.visible = true

func getHighScores(args):
	$PanelContainer/VBoxContainer/Scores.text = args[0]
	$PanelContainer/VBoxContainer/Button.visible = true


func _on_Button_pressed():
	get_tree().change_scene("res://root.tscn")
