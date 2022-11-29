extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var barFG = $"../Camera2D/CrowdScreen/Bar/FG"
var maxFGSize = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	maxFGSize = barFG.region_rect.size.x
	pass # Replace with function body.

onready var cheering = $Cheering
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !isActionScreenActive:
		return
	updateActionScreen(delta)
	pass 
	
func updateActionScreen(delta):
	updateBarVisualization()
	updatePlayerAnimation()
	updateActionScreenCharge(delta)
	updateActionScreenExit()
	pass
	
func updatePlayerAnimation():
	if playerSprite.animation == "lift_puppy" && playerSprite.frame == 3:
		playerSprite.play("hold_puppy")
	pass
	
func updateActionScreenCharge(delta):
	main.publicPerception += delta * 9.0
	main.publicPerception = clamp(main.publicPerception, 0, 100)
	pass
	
onready var player = $"../Player"
onready var playerSprite = $"../Player/Sprite"
func updateActionScreenExit():
	if Input.is_action_just_pressed("crowd_exit"):
		isActionScreenActive = false
		crowdScreenRoot.visible = false
		crowdSprite.play("default")
		playerSprite.play("default_back")
		cheering.stop()
		player.exitInteraction()
	pass

onready var main = $"../../MainGameScreen"
func updateBarVisualization():
	var finalSizeX = maxFGSize * (main.publicPerception / 100.0);
	barFG.region_rect.size.x = finalSizeX
	pass

onready var crowdScreenRoot = $"../Camera2D/CrowdScreen"
onready var crowdSprite = $AnimatedSprite
var isActionScreenActive = false
func startActionScreen():
	isActionScreenActive = true
	crowdScreenRoot.visible = true
	crowdSprite.play("happy")
	playerSprite.play("lift_puppy")
	cheering.play()
	updateBarVisualization();
	pass
