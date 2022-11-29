extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var barFusionFG = $"../Camera2D/OverviewScreen/BarFusion/FG"
onready var barPressureFG = $"../Camera2D/OverviewScreen/BarPressure/FG"
onready var barPublicityFG = $"../Camera2D/OverviewScreen/BarPublicity/FG"
var maxFGSize = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	maxFGSize = barFusionFG.region_rect.size.x
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	updateVisibility()
	if !isActionScreenActive:
		return
	updateActionScreen(delta)
	pass 
	
func updateActionScreen(_delta):
	updateBarVisualization()
	updateActionScreenExit()
	pass
	
onready var player = $"../Player"
func updateActionScreenExit():
	if Input.is_action_just_pressed("overview_exit"):
		isActionScreenActive = false
		overviewScreenRoot.visible = false
		player.exitInteraction()
	pass

onready var main = $"../../MainGameScreen"
func updateBarVisualization():
	var finalSizeX = maxFGSize * (main.energyOutput / 100.0);
	barFusionFG.region_rect.size.x = finalSizeX
	
	finalSizeX = maxFGSize * (main.pressure / 100.0);
	barPressureFG.region_rect.size.x = finalSizeX
	
	finalSizeX = maxFGSize * (main.publicPerception / 100.0);
	barPublicityFG.region_rect.size.x = finalSizeX
	pass

onready var overviewScreenRoot = $"../Camera2D/OverviewScreen"
onready var overviewScreenSprite = $"../Camera2D/OverviewScreen/AnimatedSprite"
var isActionScreenActive = false
func startActionScreen():
	isActionScreenActive = true
	overviewScreenRoot.visible = true
	overviewScreenSprite.play("default")
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
