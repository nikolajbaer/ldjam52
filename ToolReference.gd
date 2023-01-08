tool
extends MeshInstance

func _ready():
	if not Engine.editor_hint:
		visible = false
	var multimesh = get_node("../MultiMeshInstance")
	scale = Vector3(multimesh.extent,multimesh.extent,multimesh.extent)	
