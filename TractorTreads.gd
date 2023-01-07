extends MultiMeshInstance

var cursor = 0
export(int) var instance_count = 60*3*10 # 10per sec, for 3 min of play seems reasonable before we recycle?

func _ready():
	cursor = 0
	# Create the multimesh.
	multimesh = MultiMesh.new()
	multimesh.mesh = $MeshInstance.mesh
	
	# Set the format first.
	multimesh.transform_format = MultiMesh.TRANSFORM_3D
	multimesh.color_format = MultiMesh.COLOR_NONE
	multimesh.custom_data_format = MultiMesh.CUSTOM_DATA_NONE
	# Then resize (otherwise, changing the format is not allowed).
	multimesh.instance_count = instance_count
	# Maybe not all of them should be visible at first.
	multimesh.visible_instance_count = instance_count

	# Set the transform of the instances to zero at first
	for i in multimesh.visible_instance_count:
		multimesh.set_instance_transform(i, Transform().scaled(Vector3(0,0,0)))

func leave_track(pos:Vector3,yrot:float):
	var t = Transform().translated(pos) * Transform().rotated(Vector3.UP,yrot) 
	multimesh.set_instance_transform(cursor,t)
	cursor += 1
	if cursor >= multimesh.instance_count:
		cursor = 0
