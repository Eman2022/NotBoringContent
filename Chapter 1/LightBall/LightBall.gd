class_name LightBall extends RigidBody



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func setColor(color : Color):
	if color:
		var light : OmniLight = $OmniLight
		var mesh : MeshInstance = $MeshInstance
		var mat : SpatialMaterial = mesh.get_surface_material(0)
		light.light_color = color
		mat.emission = color
		mat.albedo_color = color

func getVolume() -> float:
	return 0.015;
