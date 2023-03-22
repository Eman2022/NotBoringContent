# Published to gitlab by Erich_L 2023
# To try an example, call a function below by writing it in
# under the _ready() function. Write your own code in the script
# attatched to the World node

extends School


func _ready():
	pass
#	theEveryThingExample()
#	makeHalfCircle(6.0, 14)





func theEveryThingExample():
	
	# you can chain settings:
	createBox(0,0,8).setPopMessage("Hey, don't open this!").setLabel("Socks").setSymbol("S")
	createBox(1.5,0,8).setPopMessage("BOOM!").setLabel("Bomb").setSymbol("!").setPopForce(60.0).setLabelColor(Color.brown)
	createBox(-1.5,0,8).setSymbol("Δ").setSymbolColor(Color.aquamarine).setBoxHelium(100).rotate_y(PI * 0.5)
	createBox(-1.5,1,8).setSymbol("Δ").setSymbolColor(Color.aquamarine).setBoxHelium(100).rotate_y(PI * 0.5)
	createBox(-1.5,2,8).setSymbol("X").setSymbolColor(Color.burlywood).setBoxHelium(0).setPopMessage("Fly, my babies!").setCleanUpTime(0.1).rotate_y(PI * 0.5)
	
	# or do one at a time:
	var b : Box = createBox(3,0,8)
	b.setSymbol('◈') # in Globals.gd I have listed a number of cool characters that the engine's font system supports
	b.setSymbolColor(Color.greenyellow)
	b.rotate_y(PI / 2.0)
	var inner_box = b.addBoxtoBox()
	for i in 3:
		inner_box.addLightBallToBox(Color(rand_range(0.0, 1.0),rand_range(0.0, 1.0),rand_range(0.0, 1.0)))
	
	
	# hide chippy in a stack of random boxes
	var rng : RandomNumberGenerator = RandomNumberGenerator.new()
	rng.randomize()
	var boxes : Array
	var size : int = 4
	var center : Vector3 = Vector3(-6,0,-3)
	if size > 8:
		print_debug("careful, too many boxes might kill your system!")
		size = 8
	for x in size:
		for y in size:
			for z in size:
				var pos := center + Vector3(x,y,z)
				var box : Box = createBoxV(pos)
				box.setCleanUpTime(3.5)
				box.setLabel(str(pos))
				box.rotate_y(rng.randi_range(0,4) * PI * 0.5)
				box.setSymbol(Globals.availableChars[rng.randi_range(0,59)])
				box.setSymbolColor(Color(rng.randf_range(0,1),rng.randf_range(0,1),rng.randf_range(0,1)))
				boxes.push_back(box)
	
	var s := boxes.size()
	
	var i = int(rng.randf_range(0, s - 1))
	boxes[i].addChippyToBox()
	boxes[i].setPopMessage("You found Chippy!")
	
	# small fireworks show:
	var count : int = 15
	for z in count:
		var box : Box = createBoxV(Vector3(-10 + z * 1.5,0,-7))
		box.setBoxHelium(rand_range(95,100))
		box.setAutoPop(rand_range(9,12))
		box.setPopForce(40)
		for n in 3:
			box.addLightBallToBox(Color(rand_range(0,1),rand_range(0,1),rand_range(0,1)))
		box.setSymbol("Δ").setSymbolColor(Color.aquamarine)
		box.rotate_y(rand_range(0, 2.0 * PI))
		box.setCleanUpTime(9.0)




func makeHalfCircle(radius : float = 7.0, boxCount : int = 6, position : Vector3 = Vector3(0,0,0)):
	var a : float = (2.0 * PI) / float(boxCount)
	a *= 0.5 # 0.5 for half circle
	var c := 0
	for i in boxCount:
		var b = createBox(cos(i * a) * radius, 1.0, sin(i * a) * radius)
		b.translation += position
		b.setSymbol(str(i))


func makeAGasBox(x : float, y : float, z : float) -> Box:
	var b : Box = createBox(x,y,z)
	b.setBoxHelium(100)
	b.setPopForce(17.7)
	b.setSymbol('H')
	b.setSymbolColor(Color.green)
	return b


# moving mouse across boxes or floor calls this optional function
func mousePositionUpdated(mousePosition : Vector3):
	return
	print("mousePosition: ", mousePosition)
