extends Node


var characters : Array = ['◉', '◎', '◌', '◊', '◈', '▩', '▣', '▢', '■', '▤',
'▥', '▧', '▨', '◐', '◑', '♠⛅', '♦', '♣', '☆', '★', '☏', '♡', '♨', '♬', '❖',
'↕    ', '↔', '§', '¤', '©', 'ø', '¶', 'µ', 'Ω', '∀', '∏', '∞', '∫', '⊖', 'δ', 'Δ']
var mouseDown := false


func _input(_event):
	if Input.is_action_just_pressed("mouseLeft"):
		mouseDown = true
	elif Input.is_action_just_released("mouseLeft"):
		mouseDown = false
