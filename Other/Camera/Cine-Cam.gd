class_name Cine_Cam extends Camera


export(float, 0.0,100.0) var YFocus = 0.0
export(float, 0.0,100.0) var CameraY = 12.0
var _lastA = 0.0
var _rotRadians = 0.1
export(float,0.1,10) var cameraSpeed = 1.0
export(float,8,100) var trackRadius = 12.0


# Keyboard state
var _w = false
var _s = false
var _a = false
var _d = false
var _q = false
var _e = false


# Called when the node enters the scene tree for the first time.
func _ready():
	if current:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _process(delta):
	if self.current:
		var a = _lastA + _rotRadians * cameraSpeed * delta
		var x = trackRadius * cos(a)
		var z = trackRadius * sin(a)
		_lastA = a
		if _q:
			CameraY += 2 * delta
		if _e:
			CameraY -= 2 * delta
		if _w:
			trackRadius -= 2 * delta
		if _s:
			trackRadius += 2 * delta
		if _a:
			_rotRadians += 1 * delta
		if _d:
			_rotRadians -= 1 * delta
		
		look_at_from_position(Vector3(x,CameraY,z),Vector3(0,YFocus,0),Vector3(0,1,0))

func _input(event):
		# Receives key input
	if self.current and event is InputEventKey:
		match event.scancode:
			KEY_W:
				_w = event.pressed
			KEY_S:
				_s = event.pressed
			KEY_A:
				_a = event.pressed
			KEY_D:
				_d = event.pressed
			KEY_Q:
				_q = event.pressed
			KEY_E:
				_e = event.pressed
			KEY_F:
				_e = event.pressed
