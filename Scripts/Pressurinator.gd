extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var chargeStage = 0
onready var barFG = $"../Camera2D/PressurinatorScreen/Bar/FG"#
var maxFGSize = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	maxFGSize = barFG.region_rect.size.x
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !isActionScreenActive:
		return
	updateActionScreen(delta)
	pass 
	
func updateActionScreen(delta):
	updateBarVisualization()
	updateActionScreenCharge(delta)
	updateActionScreenExit()
	updatePressAnimation(delta)
	pass
	
func updatePressAnimation(delta):
	if chargeStage < 2 || chargeStage >= 3:
		return
	chargeStage += delta
	if chargeStage > 2.40:
		pressurinatorScreenSprite.play("after_press")
		var sfxPath = "res://Sounds/pressure" + str((randi() % 11) + 1) + ".wav"
		var newSFX = load(sfxPath)
		Util.playSoundEffect(newSFX)
		chargeStage = 3
	pass
	
onready var brrtsfx = preload("res://Sounds/brrt.wav")
onready var pflamSFX = preload("res://Sounds/pflam.wav")
var pressurinatorSFXTime = 0
func updateActionScreenCharge(delta):
	if Input.is_action_pressed("pressurinator_decharge") && chargeStage < 2:
		if pressurinatorScreenSprite.animation != "charge": pressurinatorScreenSprite.play("charge")
		main.pressure -= delta * 9.0
		main.pressure = clamp(main.pressure, 0, 100)
		chargeStage = 1
		pressurinatorSFXTime += delta
		if pressurinatorSFXTime > 0.1:
			Util.playSoundEffect(brrtsfx)
			pressurinatorSFXTime = 0.0
	else:
		if chargeStage > 0 && chargeStage < 2: 
			chargeStage = 2
			pressurinatorScreenSprite.play("press")
			Util.playSoundEffect(pflamSFX)
		elif pressurinatorScreenSprite.animation == "charge": pressurinatorScreenSprite.play("default")
		
	pass
	
onready var player = $"../Player"
func updateActionScreenExit():
	if Input.is_action_just_pressed("pressurinator_exit"):
		isActionScreenActive = false
		pressurinatorScreenRoot.visible = false
		player.exitInteraction()
	pass

onready var main = $"../../MainGameScreen"
func updateBarVisualization():
	var finalSizeX = maxFGSize * (main.pressure / 100.0);
	barFG.region_rect.size.x = finalSizeX
	pass

onready var pressurinatorScreenRoot = $"../Camera2D/PressurinatorScreen"
onready var pressurinatorScreenSprite = $"../Camera2D/PressurinatorScreen/AnimatedSprite"
var isActionScreenActive = false
func startActionScreen():
	isActionScreenActive = true
	pressurinatorScreenRoot.visible = true
	pressurinatorScreenSprite.play("default")
	chargeStage = 0
	pressurinatorSFXTime = 0
	updateBarVisualization();
	pass
