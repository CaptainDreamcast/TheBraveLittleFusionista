extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var energyOutput = 50.0
var pressure = 50.0
var publicPerception = 50.0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var gameTime = 60.0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	updateVariables(delta)
	updateTime(delta)
	updateGameOver()
	pass

func updateVariables(delta):
	if !tutorialManager.isTutorialOver:
		return
		
	energyOutput -= delta
	pressure += (2.0 * (energyOutput / 100.0)) * delta
	publicPerception -= delta
	pass

onready var tutorialManager = $TutorialManager
onready var timeField = $Camera2D/UI/Time
func updateTime(delta):
	if !tutorialManager.isTutorialOver:
		timeField.text = "12 AM"
		return
		
	gameTime += delta * 1
	if gameTime < 60.0 * 1.0:
		timeField.text = "12 AM"
	elif gameTime < 60.0 * 2.0:
		timeField.text = "1 AM"
	elif gameTime < 60.0 * 3.0:
		timeField.text = "2 AM"
	elif gameTime < 60.0 * 4.0:
		timeField.text = "3 AM"
	elif gameTime < 60.0 * 5.0:
		timeField.text = "4 AM"
	elif gameTime < 60.0 * 6.0:
		timeField.text = "5 AM"
	elif gameTime < 60.0 * 7.0:
		timeField.text = "6 AM"
		
	
	pass

func updateGameOver():
	if pressure > 100.0:
		var _changed = get_tree().change_scene("res://Screens/LosingScreen.tscn");
	elif publicPerception < 0.0:
		var _changed = get_tree().change_scene("res://Screens/LosingScreen2.tscn");
	elif energyOutput < 0.0:
		var _changed = get_tree().change_scene("res://Screens/LosingScreen3.tscn");
	elif gameTime >= 60 * 6.0:
		var _changed = get_tree().change_scene("res://Screens/WinningScreen.tscn");
	pass
