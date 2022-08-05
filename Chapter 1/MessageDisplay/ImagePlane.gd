tool
extends MeshInstance



export var labelPath : NodePath


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	mesh.size = get_node(labelPath).rect_size * 0.01
