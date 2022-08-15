class_name BoxLabel extends Label3D


var size = "L"

func setText(t : String):
	self.text = t
	if size == "M":
		var adjuster = 0.0
		var l = t.length()
		if l > 7:
			var d = l - 7
			adjuster = 0.0007 * sqrt(d)
		pixel_size = 0.005 - adjuster

func setColor(c : Color):
	if c:
		self.modulate = c

func _init(spot : int, t : String, c : Color = Color.white):
	
	self.shaded = true
	self.font = load("res://Other/UI/BaseFont.tres")

	if spot == 1 or spot == 3:
		size = "M"
		var adjuster = 1.0
		
		var l = t.length()
		if l > 7:
			var d = l - 7
			adjuster = 1 / d
		pixel_size = 0.005 * adjuster
	else:
		pixel_size = 0.02
		self.translation.y = 0.1
	
	adjust(spot)

	
	setText(t)
	setColor(c)

func adjust(spot : int):
	match spot:
		1:
			self.translation.z = 0.01
		2:
			self.translation.x = -0.01
			self.rotation_degrees.y = -90
		3:
			self.translation.z = -0.01
			self.rotation_degrees.y = -180
		4:
			self.translation.x = 0.01
			self.rotation_degrees.y = 90
