extends Node


var mouseDown := false


func _input(event):
	if Input.is_action_just_pressed("mouseLeft"):
		mouseDown = true
	elif Input.is_action_just_released("mouseLeft"):
		mouseDown = false
