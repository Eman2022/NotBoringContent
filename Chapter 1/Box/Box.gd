class_name Box extends RigidBody

var boxSidesFile = preload("res://Chapter 1/Box/BoxSide.tscn")

signal oxygenChanged(oxygenAmount)

signal boxPopping(data)

var meshOffset : Vector3
var _contents : Array 
var boxName : String = "box"
var worldNode
var _popMessage : String
var _messager : Messager
var _popForce : float = 1
var _canOpen : bool = true
var busyOpening := false
var audioPlayer : AudioStreamPlayer3D
var cryPlayer : AudioStreamPlayer3D
var _cleanUpTime : float = -1.0
var _chippyAdded : bool = false
var _boxOxygen : float = 100.0
var _boxHelium : float = 0.0
var _realOx : float = 100.0
var _realHel : float = 0.0
var _bumpTimer : Timer
var _applyPopTorque : bool = true
var sizeOverride : float = 1
var _autoPopTime : float = -1
var _volumeRemaining : float = 1.0
var _parentBox
var lastAddBoxVolume : float = 0
var data : Dictionary = {}


func _init():
	meshOffset = Vector3(rand_range(0.0,1.0),rand_range(0.0,1.0),0.0)
	setCanOpen(_canOpen)



func _ready():
	worldNode = get_parent()
	var mesh : MeshInstance = get_child(0)
	var sm : SpatialMaterial = mesh.get_surface_material(0)
	sm.uv1_offset = meshOffset
	if _autoPopTime > -1:
		createSetPopTimer()


func _on_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if !event.pressed:
			popOpenBox()
	elif event is InputEventMouseMotion:
		worldNode.mousePositionUpdated(position)
		if Globals.mouseDown:
			popOpenBox()

func popOpenBox():
	if !busyOpening and _canOpen:
		emit_signal("boxPopping",self.data)
		busyOpening = true
		var p = get_parent()
		
		spawnBoxSide(1, 2)
		spawnBoxSide(2, 3, Vector3(0,1.5,0))
		spawnBoxSide(3, 4, Vector3(0,1.5,0))
		spawnBoxSide(4, 5, Vector3(0,1.5,0))
		spawnBoxSide(5, 6, Vector3(0,1.5,0))
		spawnBoxSide(6, 7, Vector3(0,1.5,0))
		
		for obj in _contents:
			p.add_child(obj)
			obj.transform = self.transform
		if _popMessage and _messager:
			_messager.updateText(_popMessage, self.translation)
		elif _popMessage and !_messager:
			setPopMessage(_popMessage)
			if _messager:
				_messager.updateText(_popMessage, self.translation)
			
		if audioPlayer:
			audioPlayer.transform = self.transform
			get_parent().add_child(audioPlayer)
			audioPlayer.play(0.2)
		
		self.queue_free()

func spawnBoxSide(spot : int, child : int, uvOffset : Vector3 = Vector3(0,0,0)):
	var p : Vector3 = self.translation
	var boxSide = boxSidesFile.instance()
	
	var boxMesh : MeshInstance = boxSide.get_node("MeshInstance")
	boxMesh.mesh.size *= self.sizeOverride
	var collider : CollisionShape = boxSide.get_node("CollisionShape")
	collider.shape.extents *= self.sizeOverride
	
	if _cleanUpTime >= 0:
		boxSide.setCleanUpTime(_cleanUpTime)

	var spotChild : Spatial = get_child(child)
	boxSide.transform = spotChild.get_global_transform()
	if spot == 2 or spot == 4:
		boxSide.rotation_degrees.y += 90
	elif spot == 5 or spot == 6:
		boxSide.rotation_degrees.x += 90
		boxSide.scale = Vector3(0.8,0.8,1.0)
	elif spot == 3:
		boxSide.rotation_degrees.y += 180
	get_parent().add_child(boxSide)

	if _chippyAdded and _popForce < 2.0:
		_popForce += 4.0

	var dir = (boxSide.translation - self.translation) * _popForce
	
	boxSide.apply_central_impulse(dir)
	if _applyPopTorque:
		boxSide.apply_torque_impulse(Vector3(rand_range(-1,1),rand_range(-1,1),rand_range(-1,1)).normalized() * _popForce * 0.1)

func setPopForce(force : float = 1.0):
	if force:
		self._popForce = force

func setPopApplyTorque(val : bool):
	_applyPopTorque = val

func setPopMessage(message = "Pop!"):
	if message:
		if !message is String:
			message = String(message)
		_popMessage = message
		
		
		
		if !message.empty():
			_popMessage = message
			var p = get_parent()
			if p:
				for c in p.get_children():
					if c is Messager:
						self._messager = c
						break
		return self

func setCanOpen(canOpen : bool):
	self._canOpen = canOpen
	if canOpen and !audioPlayer:
		audioPlayer = AudioStreamPlayer3D.new()
		var ax : AudioStreamMP3 = load("res://Chapter 1/Box/pop-39222.mp3")
		ax.loop = false
		audioPlayer.set_stream(ax)
		audioPlayer.autoplay = false
		audioPlayer.connect("finished",audioPlayer,"queue_free")

func setCleanUpTime(timeSeconds : float):
	if timeSeconds >= 0:
		self._cleanUpTime = timeSeconds

func setAutoPop(timeSeconds : float):
	if timeSeconds < 0:
		timeSeconds = 0
	self._autoPopTime = timeSeconds
	if get_parent():
		createSetPopTimer()

func createSetPopTimer():
	var timer : Timer = Timer.new()
	timer.one_shot = true
	add_child(timer)
	timer.connect("timeout",self,"popOpenBox")
	timer.start(_autoPopTime)
	_autoPopTime = -1

func addChippyToBox() -> Box:
	var chippy = load("res://Chapter 1/Chippy/chippy.tscn")
	pushInstanceIntoBox(chippy.instance())
	if !_chippyAdded:
		_chippyAdded = true
		var timer : Timer = Timer.new()
		timer.autostart = true
		timer.wait_time = 3.0
		add_child(timer)
		timer.connect("timeout",self, "everyThreeSeconds")
		_bumpTimer = timer
		
		
		cryPlayer = AudioStreamPlayer3D.new()
		var ax : AudioStreamOGGVorbis = load("res://Chapter 1/Chippy/chippySound.ogg")
		ax.loop = true
		cryPlayer.set_stream(ax)
		cryPlayer.max_distance = 15
		cryPlayer.attenuation_model = AudioStreamPlayer3D.ATTENUATION_INVERSE_SQUARE_DISTANCE
		cryPlayer.unit_db = 5.0
		cryPlayer.autoplay = true
		add_child(cryPlayer)
	return self

func everyThreeSeconds():
	if self.sleeping and self._boxOxygen <= 20.0:
		bumpBox(1.0)
		setBoxOxygen(_boxOxygen - 4)
	else:
		setBoxOxygen(_boxOxygen - 5)
	if _boxOxygen <= 0.0:
		var chippy = findChippy()
		if chippy:
			chippy.hp -= 1
			if chippy.hp <= 0:
				chippyHasDied()


func figureTotalHelium():
	var total = self._realHel
	for thing in _contents:
		if thing.has_method("figureTotalHelium"):
			total += thing.figureTotalHelium()
	return total

func figureGravityScale():
	if get_parent():
		
		var totalHelium = figureTotalHelium()
		self.gravity_scale = range_lerp(totalHelium,0,100 * self.sizeOverride,1,-0.1)
		self.gravity_scale = clamp(self.gravity_scale,-0.1,1.0)
	else:
		if _parentBox:
			_parentBox.figureGravityScale()
#		var upperParent = _parentBox
#		var i = 0
#		while(!upperParent.is_inside_tree()):
#			i += 1
#			upperParent = _parentBox._parentBox
#			if upperParent.get_parent():
#				break
#		upperParent.figureGravityScale()
		


func chippyHasDied():
	setPopMessage("...")
	print("Chippy has died!")
	_removeChippyFromBox()
	_bumpTimer.queue_free()
	cryPlayer.stop()
	cryPlayer.queue_free()
	var skullFile = load("res://Chapter 1/Chippy/skull.tscn")
	var skull = skullFile.instance()
	_contents.push_back(skull)

func _removeChippyFromBox():
	for i in range(_contents.size()):
		if _contents[i] is Chippy:
			_contents.remove(i)
			break


func bumpBox(strength : float):
	var randDirection = Vector3(rand_range(-1,1),rand_range(-1,1),rand_range(-1,1)).normalized()
	var desperation = range_lerp(abs(10.0 - _boxOxygen),0,10,6,1)
	randDirection *= strength * desperation
	self.apply_central_impulse(randDirection)


func findChippy() -> Chippy:
	if !_chippyAdded:
		return null
	else:
		for item in _contents:
			if item is Chippy:
				return item
		return null

func setBoxHelium(amount : float):
	_boxHelium = clamp(amount,0,100)
	_realHel = _boxHelium * _volumeRemaining
	if _boxHelium + _boxOxygen > 100:
		var toRemove = _boxHelium + _boxOxygen - 100.0
		setBoxOxygen(_boxOxygen - toRemove)
	figureGravityScale()

func getBoxHelium() -> float:
	return _boxHelium

func getBoxOxygen() -> float:
	return _boxOxygen

func setBoxOxygen(amount : float):
	_boxOxygen = clamp(amount, 0, 100)
	_realOx = _boxOxygen * _volumeRemaining
	emit_signal("oxygenChanged",_boxOxygen)
	if _boxHelium + _boxOxygen > 100:
		var toRemove = _boxHelium + _boxOxygen - 100.0
		setBoxHelium(_boxHelium - toRemove)


func addLightBallToBox(color : Color):
	var lightBall = load("res://Chapter 1/LightBall/LightBall.tscn")
	var lb : LightBall = lightBall.instance()
	lb.setColor(color)
	pushInstanceIntoBox(lb)
	return self

func pushInstanceIntoBox(newThing) -> bool:
	if _volumeRemaining >= newThing.getVolume():
		reduceVolume(newThing.getVolume())
		_contents.push_back(newThing)
		return true
	else:
		print(name + " didn't have enough space for " + newThing.name)
		return false

func getVolume():
	return 1.0 * sizeOverride

func addBoxtoBox() -> Box:

	var totalBoxes = 1.0
	for thing in _contents:
		if thing.has_method("popOpenBox"):
			totalBoxes += 1.0
	
	var bxPath = load("res://Chapter 1/Box/Box.tscn")
	var bxInst = bxPath.instance()
	var boxPlaced = false
	if containsObjectOtherThanBoxes():
		print(boxName + " has something besides boxes")
		if pushInstanceIntoBox(bxInst):
			boxPlaced = true
	else:
		reduceVolume(bxInst.getVolume())
		_contents.push_back(bxInst)
		boxPlaced = true
	if boxPlaced:
		var newSize = (0.95 * self.sizeOverride) / totalBoxes
		bxInst.setSizeOverride(newSize)
		bxInst._parentBox = self
		if totalBoxes == 1:
			reduceVolume(_volumeRemaining)
		for thing in _contents:
			if thing.has_method("popOpenBox"):
				thing.setSizeOverride(newSize)
		return bxInst

	print("ERROR, box couldn't fit inside box")
	return null


func containsObjectOtherThanBoxes() -> bool:
	for thing in _contents:
		if !thing.has_method("popOpenBox"):
			return true
	return false
		

func reduceVolume(amt : float):
	_volumeRemaining -= amt
	_realHel = _boxHelium * _volumeRemaining * sizeOverride
	_realOx = _boxOxygen * _volumeRemaining * sizeOverride
	figureGravityScale()

func setSizeOverride(size : float):
	self.sizeOverride = size
	self._volumeRemaining = size
	var mesh : MeshInstance = get_node("MeshInstance")
	mesh.mesh.size = Vector3(1,1,1) * size
	var collider : CollisionShape = get_node("CollisionShape")
	collider.shape.extents = Vector3(0.5,0.5,0.5) * size



func _on_tree_entered():
	figureGravityScale()