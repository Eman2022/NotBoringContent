extends Node


var availableChars : Array = ['◉', '◎', '◌', '◊', '◈', '▩', '▣', '▢', '■', '▤',
'▥', '▧', '▨', '◐', '◑', '♠⛅', '♦', '♣', '☆', '★', '☏', '♡', '♨', '♬', '❖',
'↕', '↔', '§', '¤', '©', 'ø', '¶', 'µ', 'Ω', '∀', '∏', '∞', '∫', '⊖', 'δ', 'Δ',
'米', '奶', '茶', '酒','鱼','蜘','铁','金','糖','椒','水','衣','银','木','毛','珠',
'肥','布','机']


var cn : Dictionary = {
	"Rice" : "米",
	"Salt," : "奶",
	"Tea" : "茶",
	"Spirits," : "酒",
	"Fish" : "鱼",
	"Spiders" : "蜘",
	"Iron" : "铁",
	"Gold" : "金",
	"Candy" : "糖",
	"Pepper," : "椒",
	"Water" : "水",
	"Clothes": "衣",
	"Silver" : "银",
	"Wood" : "木",
	"Wool" : "毛",
	"Jewelry":"珠",
	"Fertilizer" : "肥",
	"Fabric" : "布",
	"Machinery" : "机"
}


var mouseDown := false

func _input(_event):
	if Input.is_action_just_pressed("mouseLeft"):
		mouseDown = true
	elif Input.is_action_just_released("mouseLeft"):
		mouseDown = false
