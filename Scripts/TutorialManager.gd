extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var clips = [preload("res://Sounds/tutorial1.wav"), preload("res://Sounds/tutorial2.wav"), preload("res://Sounds/tutorial3.wav"), preload("res://Sounds/tutorial4.wav"), preload("res://Sounds/tutorial5.wav"), preload("res://Sounds/tutorial6.wav"), preload("res://Sounds/tutorial7.wav"), preload("res://Sounds/tutorial8.wav"), preload("res://Sounds/tutorial9.wav"), preload("res://Sounds/tutorial10.wav")]
onready var audioPlayer = $ClipPlayer
var isTutorialOver = false
# Called when the node enters the scene tree for the first time.
func _ready():
	if GameLogic.hasFinishedTutorial:
		isTutorialOver = true
		tutorialStage = 100
		return
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	updateTutorialStage()
	pass
	
var tutorialStage = 0
onready var camera = $"../Camera2D"
onready var fusionator = $"../Fusionator"
onready var pressurinator = $"../Pressurinator"
onready var crowd = $"../Crowd"
onready var overview = $"../Overview"
onready var door = $"../Door"
func updateTutorialStage():
	if audioPlayer.playing:
		return
	
	if tutorialStage == 0:
		audioPlayer.stream = clips[0]
		audioPlayer.play()
		tutorialStage += 1
	elif tutorialStage == 1:
		audioPlayer.stream = clips[1]
		audioPlayer.play()
		tutorialStage += 1
	elif tutorialStage == 2:
		audioPlayer.stream = clips[2]
		audioPlayer.play()
		camera.swerveToPos(fusionator.position - Vector2(320, 240))
		tutorialStage += 1
	elif tutorialStage == 3 && fusionator.isActionScreenActive:
		audioPlayer.stream = clips[3]
		audioPlayer.play()
		tutorialStage += 1
	elif tutorialStage == 4 && !fusionator.isActionScreenActive:
		audioPlayer.stream = clips[4]
		audioPlayer.play()
		camera.swerveToPos(pressurinator.position - Vector2(0, 120))
		tutorialStage += 1
	elif tutorialStage == 5 && pressurinator.isActionScreenActive:
		audioPlayer.stream = clips[5]
		audioPlayer.play()
		tutorialStage += 1
	elif tutorialStage == 6 && !pressurinator.isActionScreenActive:
		audioPlayer.stream = clips[6]
		audioPlayer.play()
		camera.swerveToPos(crowd.position - Vector2(160, 120))
		tutorialStage += 1
	elif tutorialStage == 7:
		audioPlayer.stream = clips[7]
		audioPlayer.play()
		camera.swerveToPos(overview.position - Vector2(160, 200))
		tutorialStage += 1
	elif tutorialStage == 8:
		audioPlayer.stream = clips[8]
		audioPlayer.play()
		camera.swerveToPos(door.position - Vector2(160, 240))
		tutorialStage += 1
	elif tutorialStage == 9:
		audioPlayer.stream = clips[9]
		audioPlayer.play()
		tutorialStage += 1
	elif tutorialStage == 10:
		isTutorialOver = true
		GameLogic.hasFinishedTutorial = true
	pass
