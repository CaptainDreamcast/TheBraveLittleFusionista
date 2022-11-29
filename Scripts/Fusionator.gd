extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var barFG = $"../Camera2D/FusionatorScreen/Bar/FG"#
var maxFGSize = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	maxFGSize = barFG.region_rect.size.x
	pass # Replace with function body.

var lastFrameFrame = -1
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	updateVisibility()
	if !isActionScreenActive:
		return
	updateActionScreen(delta)
	pass 
	
func updateActionScreen(delta):
	updateBarVisualization()
	updateActionScreenCharge(delta)
	updateActionScreenExit()
	pass
	
onready var clapSFX = preload("res://Sounds/clap.wav")
func updateActionScreenCharge(delta):
	if Input.is_action_pressed("fusionator_charge"):
		if fusionatorScreenSprite.animation != "active": fusionatorScreenSprite.play("active")
		main.energyOutput += delta * 9.0
		main.energyOutput = clamp(main.energyOutput, 0, 100)
		if fusionatorScreenSprite.frame == 1 && fusionatorScreenSprite.frame != lastFrameFrame:
			Util.playSoundEffect(clapSFX)
		lastFrameFrame = fusionatorScreenSprite.frame
	else:
		if fusionatorScreenSprite.animation == "active": fusionatorScreenSprite.play("default")
		lastFrameFrame = 0
	pass
	
onready var player = $"../Player"
func updateActionScreenExit():
	if Input.is_action_just_pressed("fusionator_exit"):
		isActionScreenActive = false
		fusionatorScreenRoot.visible = false
		player.exitInteraction()
	pass

onready var main = $"../../MainGameScreen"
func updateBarVisualization():
	var finalSizeX = maxFGSize * (main.energyOutput / 100.0);
	barFG.region_rect.size.x = finalSizeX
	pass

onready var fusionatorScreenRoot = $"../Camera2D/FusionatorScreen"
onready var fusionatorScreenSprite = $"../Camera2D/FusionatorScreen/AnimatedSprite"
var isActionScreenActive = false
func startActionScreen():
	isActionScreenActive = true
	fusionatorScreenRoot.visible = true
	fusionatorScreenSprite.play("default")
	updateBarVisualization();
	pass
	
onready var area = $TransArea/CollisionShape2D
func updateVisibility():
	if Util.isInCollisionShapeRect(area, player.position):
		self.modulate.a = 0.5
		self.z_index = 50
	else:
		self.modulate.a = 1.0
		self.z_index = 0
	pass
