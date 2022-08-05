class_name ScreenText extends Control


func _ready():
	$MiddleText.visible = false
	$UpperText.visible = false
	$MiddleTextTimer.connect("timeout",self,"hideMiddleText")
	$UpperTextTimer.connect("timeout",self,"hideUpperText")


func setMiddleText(text : String, timeSeconds : float = 3.0):
	if text and !text.empty():
		$MiddleText.text = text
		$MiddleText.visible = true
		timeSeconds = clamp(timeSeconds, 0.0, INF)
		$MiddleTextTimer.start(timeSeconds)

func setUpperText(text : String, timeSeconds : float = 3.0):
	if text and !text.empty():
		$UpperText.text = text
		$UpperText.visible = true
		timeSeconds = clamp(timeSeconds, 0.0, INF)
		$UpperTextTimer.start(timeSeconds)

func hideMiddleText():
	$MiddleText.visible = false

func hideUpperText():
	$UpperText.visible = false
