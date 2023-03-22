class_name FreelookCamera extends Camera

export(float, 0.0, 1.0) var sensitivity = 1.0

# Mouse state
var _mouse_position = Vector2(0.0, 0.0)
var _total_pitch = 0.0
export var mouseLock = true
# Movement state
var _direction = Vector3(0.0, 0.0, 0.0)
var _velocity = Vector3(0.0, 0.0, 0.0)
var _acceleration = 15
var _deceleration = -10
var _vel_multiplier = 10


var cine_cam : Camera

# Keyboard state
var _w = false
var _s = false
var _a = false
var _d = false
var _q = false
var _e = false

func _ready():
	if(mouseLock):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	for c in get_parent().get_children():
		if c is Cine_Cam:
			cine_cam = c; break

func swapCameras():
	if cine_cam:
		if self.current:
			cine_cam.make_current()
			mouseLock = false
		else:
			self.make_current()
			mouseLock = true

func _input(event):
	# Receives mouse motion
	if event is InputEventMouseMotion:
		_mouse_position = event.relative
	elif Input.is_action_just_pressed("rotateAboutOrigin"):
		swapCameras()
	elif Input.is_action_pressed("captureMouse"):
		mouseLock = !mouseLock
	elif Input.is_action_pressed("exit"):
		get_tree().quit(0)
	if mouseLock:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			
			
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


func _process(delta):
	if self.current:
		_update_mouselook()
		_update_movement(delta)

func _update_movement(delta):
	# Computes desired direction from key states
	_direction = Vector3(_d as float - _a as float, 
						 _e as float - _q as float,
						 _s as float - _w as float)

	var offset = _direction.normalized() * _acceleration * _vel_multiplier * delta \
		+ _velocity.normalized() * _deceleration * _vel_multiplier * delta

	if _direction == Vector3.ZERO and offset.length_squared() > _velocity.length_squared():
		_velocity = Vector3.ZERO
	else:
		_velocity.x = clamp(_velocity.x + offset.x, -_vel_multiplier, _vel_multiplier)
		_velocity.y = clamp(_velocity.y + offset.y, -_vel_multiplier, _vel_multiplier)
		_velocity.z = clamp(_velocity.z + offset.z, -_vel_multiplier, _vel_multiplier)
	
		translate(_velocity * delta)

# Updates mouse look 
func _update_mouselook():
	if mouseLock:
		_mouse_position *= sensitivity
		var yaw = _mouse_position.x
		var pitch = _mouse_position.y
		_mouse_position = Vector2(0, 0)

		pitch = clamp(pitch, -90 - _total_pitch, 90 - _total_pitch)
		_total_pitch += pitch
		rotate_y(deg2rad(-yaw))
		rotate_object_local(Vector3(1,0,0), deg2rad(-pitch))
