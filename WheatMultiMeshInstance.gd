extends MultiMeshInstance

export(NodePath) onready var meshNode
export(int) var count = 10000
export(float) var spacing = 0.5
export(float) var extent = 100
var total_harvest
var stalks


func _ready():
	stalks = []
	total_harvest = 0

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
		var x = i%extent * spacing
		var z = int(i/extent) * spacing
		var p = Vector3(extent/2-x, 0, extent/2- z )
		multimesh.set_instance_transform(i, Transform(Basis(), p))
		stalks.append(p)

func harvest(point:Vector3,radius:float):
	# TODO figure out why this isn't working!
	# increment total_harvest
	var harvest = 0
	for i in range(len(stalks)):
		var p = stalks[i]
		if p != null:
			var d = (p-point).length()
			if d <= radius:
				print("hit!")
				stalks[i] = null
				multimesh.set_instance_transform(i,Transform.IDENTITY.scaled(Vector3(0.1,0.1,0.1)))
				harvest += 1
	total_harvest += harvest
	return harvest
