extends StaticBody

var worldNode

func _ready():
	worldNode = get_parent()


func _on_body_entered(body):
	if body is RigidBody:
		body.queue_free()


func _on_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseMotion:
		worldNode.mousePositionUpdated(position)
	elif event is InputEventMouseButton:
		if event.pressed:
			if worldNode.has_method("explosion"):
				worldNode.explosion(position.x,position.y,position.z,15)
