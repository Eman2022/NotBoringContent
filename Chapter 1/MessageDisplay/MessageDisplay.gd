class_name Messager extends Spatial


export var label : NodePath
var timer : Timer
var player : FreelookCamera

func _ready():

	self.timer = $Timer
	var c1 : Viewport = get_child(0)
	findCamera()

func updateText(text : String, pos : Vector3, seconds : float = 7.0):
	if text and player and !text.empty() and get_node(label) is Label:
		var l : Label = get_node(label)
		l.text = text

		self.visible = true
		seconds -= timer.time_left
		timer.start(seconds)

		self.translation = pos

func _on_timeout():
	self.visible = false

func findCamera():
	var p = get_parent()
	for c in p.get_children():
		if c is FreelookCamera:
			player = c
			break
