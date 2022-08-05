extends RigidBody


var _cleanUpTime : float = -1


func _ready():
	if _cleanUpTime >= 0:
		var timer = Timer.new()
		add_child(timer)
		timer.connect("timeout",self,"queue_free")
		timer.start(_cleanUpTime)

func setCleanUpTime(time : float):
	_cleanUpTime = time
