extends MultiMeshInstance

var WheatCollide = preload('res://WheatCollide.tscn')
var wheat_material = preload('res://Wheat.tres')

export(Mesh) var mesh
export(int) var extent = 50
var count
export(float) var spacing = 0.5

var stalks
var total_harvest

func _ready():
	stalks = []
	total_harvest = 0
	count = extent * extent

	# Create the multimesh.
	multimesh = MultiMesh.new()
	if mesh: multimesh.mesh = mesh
	self.material_override = wheat_material
	
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
		var hw = (extent/2) * spacing
		var p = Vector3(x-hw+(spacing/2-spacing*randf()*0.15), 0, z-hw+(spacing/2-spacing*randf()*0.15))
		stalks.append(p)
		var s = randf()*0.4 + 0.8
		var t =  Transform.scaled(Vector3(1,s,1)) * Transform(Basis(),p)
		multimesh.set_instance_transform(i, t)
		var collider = WheatCollide.instance()
		collider.connect('harvested',self,'on_harvested',[i])
		collider.translation = p	
		add_child(collider)
		
		
func on_harvested(i):
	multimesh.set_instance_transform(i,Transform(Basis(),Vector3(0,-10,0)))
	total_harvest += 1
