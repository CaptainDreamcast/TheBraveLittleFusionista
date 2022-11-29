extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	GameLogic.hasFinishedTutorial = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	updateAppearance(delta)
	updateInput()
	pass


var cycle = 1.0
var index = 0
onready var images = [preload("res://Textures/TITLE4.png"), preload("res://Textures/TITLE3.png"), preload("res://Textures/TITLE2.png"), preload("res://Textures/TITLE1.png")]

onready var sprite = $Sprite
onready var sprite2 = $Sprite2
func updateAppearance(delta):
	cycle += delta
	if cycle <= 1.0:
		sprite2.modulate.a = cycle
		pass
	elif cycle > 3.0:
		cycle -= 3.0
		index = (index + 1) % 4
		sprite.texture = sprite2.texture
		sprite2.texture = images[index]
		sprite2.modulate.a = 0.0
		pass
	else:
		sprite2.modulate.a = 1.0
		pass
	
	pass

onready var titleSFX = preload("res://Sounds/title_yeahea.wav")
onready var fadeOut = $Camera2D/FadeOut
func updateInput():
	if Input.is_action_just_pressed("title_confirm"):
		Util.playSoundEffect(titleSFX)
		var cb = funcref(self, "gotoGameScreen")
		fadeOut.startFadeout(1.0, cb)
	pass

func gotoGameScreen():
	var _changed = get_tree().change_scene("res://Screens/MainGameScreen.tscn");
	pass
