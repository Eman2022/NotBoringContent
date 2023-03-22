# Published to gitlab by Erich_L 2023
# Basic functionality from school class extension (do not delete)
extends School 



func _ready():
	var b : Box = createBox(0,0,0)
	b.setPopMessage("Hello World")
	b.setSymbol('木')
	b.setSymbolColor(Color.brown)
	b.setLabel("Hello")



# start making your own functions below! Or look at Teacher_Examples first!
# Happy Learning












# moving mouse across boxes or floor calls this optional function
func mousePositionUpdated(mousePosition : Vector3):
	pass

