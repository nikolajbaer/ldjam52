extends MultiMeshInstance

export(NodePath) onready var meshNode
export(int) var count = 10000
export(float) var spacing = 0.5

func _ready():
	var meshNodeInstance = get_node_or_null(meshNode)
	var mesh = null
	if meshNodeInstance is MeshInstance:
		mesh = (meshNodeInstance as MeshInstance).mesh
		
	# Create the multimesh.
	multimesh = MultiMesh.new()
	if mesh: multimesh.mesh = mesh
	
	# Set the format first.
	multimesh.transform_format = MultiMesh.TRANSFORM_3D
	multimesh.color_format = MultiMesh.COLOR_NONE
	multimesh.custom_data_format = MultiMesh.CUSTOM_DATA_NONE
	# Then resize (otherwise, changing the format is not allowed).
	multimesh.instance_count = count
	# Maybe not all of them should be visible at first.
	multimesh.visible_instance_count = count

	# Set the transform of the instances.
	for i in multimesh.visible_instance_count:
		var x = i%100 * spacing
		var z = int(i/100) * spacing
		multimesh.set_instance_transform(i, Transform(Basis(), Vector3(50-x, 0,50- z )))
