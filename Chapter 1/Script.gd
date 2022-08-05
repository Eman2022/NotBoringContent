extends Spatial


# Our Main function:
func _ready():
	createBox(0,0,0)




var boxScene = preload("res://Chapter 1/Box/Box.tscn")
func createBox(x : float, y : float, z : float) -> Box:
	var box = boxScene.instance()
	box.translation = Vector3(x,y,z)
	box.set_rotation_degrees(Vector3(0,round(rand_range(0.0,4.0)) * 90.0,0))
	add_child(box, true)
	return box

func mousePositionUpdated(mousePosition : Vector3):
	pass
