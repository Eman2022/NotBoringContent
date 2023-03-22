class_name School extends Spatial

var boxScene = preload("res://Chapter 1/Box/Box.tscn")



func createBox(x : float, y : float, z : float) -> Box:
	var box = boxScene.instance()
	box.translation = Vector3(x,y,z)
	add_child(box, true)
	return box
	
func createBoxV(vector3 : Vector3) -> Box:
	var box = boxScene.instance()
	box.translation = vector3
	add_child(box, true)
	return box
