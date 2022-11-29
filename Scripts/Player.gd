extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	updateMovement(delta)
	updateInteraction()
	pass
	
func updateInteraction():
	if isInteractionActive:
		return
		
	updateInteractionPossible()
	updateInteractionStart()
	updateInteractionVisualization()
	pass
	
var isInteractionActive = false
var isInteractionPossible = false
func updateInteractionPossible():
	isInteractionPossible = false
	isInteractionPossible = isInteractionPossible || isInteractionPossibleFusionator()
	isInteractionPossible = isInteractionPossible || isInteractionPossiblePressurinator() || isInteractionPossibleCrowd() || isInteractionPossibleOverview()
	pass
	
onready var interactSprite = $InteractSprite
func updateInteractionVisualization():
	if isInteractionPossible:
		interactSprite.visible = true
	else:
		interactSprite.visible = false
	pass

onready var fusInterArea = $"../Fusionator/InteractionArea/CollisionShape2D"
func isInteractionPossibleFusionator():
	return Util.isInCollisionShapeRect(fusInterArea, self.position)

onready var pressInterArea = $"../Pressurinator/InteractionArea/CollisionShape2D"
func isInteractionPossiblePressurinator():
	return Util.isInCollisionShapeRect(pressInterArea, self.position)

onready var crowdInterArea = $"../Crowd/InteractionArea/CollisionShape2D"
func isInteractionPossibleCrowd():
	return Util.isInCollisionShapeRect(crowdInterArea, self.position)

onready var overviewInterArea = $"../Overview/InteractionArea/CollisionShape2D"
func isInteractionPossibleOverview():
	return Util.isInCollisionShapeRect(overviewInterArea, self.position)


func updateInteractionStart():
	if isInteractionPossible && Input.is_action_just_pressed("interact"):
		startInteractionEligible()
	pass
	
func startInteractionEligible():
	if isInteractionPossibleFusionator():
		startInteractionFusionator()
	elif isInteractionPossiblePressurinator():
		startInteractionPressurinator()
	elif isInteractionPossibleCrowd():
		startInteractionCrowd()
	elif isInteractionPossibleOverview():
		startInteractionOverview()
	pass
	
onready var fusionator = $"../Fusionator"
func startInteractionFusionator():
	fusionator.startActionScreen()
	isInteractionPossible = false
	isInteractionActive = true
	pass

onready var pressurinator = $"../Pressurinator"
func startInteractionPressurinator():
	pressurinator.startActionScreen()
	isInteractionPossible = false
	isInteractionActive = true
	pass
	
onready var crowd = $"../Crowd"
func startInteractionCrowd():
	crowd.startActionScreen()
	isInteractionPossible = false
	isInteractionActive = true
	pass
	
onready var noiseSFX = preload("res://Sounds/noise.wav")
onready var overview = $"../Overview"
func startInteractionOverview():
	overview.startActionScreen()
	Util.playSoundEffect(noiseSFX)
	isInteractionPossible = false
	isInteractionActive = true
	pass

func exitInteraction():
	isInteractionActive = false
	pass

onready var sprite = $Sprite
var speed = 200
func updateMovement(delta):
	if isInteractionActive:
		return
	
	var moveSpeed = speed * delta;
	var movementVector = Vector2(0,0)
	if Input.is_action_pressed("move_left"):
		movementVector.x -= 1.0
	if Input.is_action_pressed("move_right"):
		movementVector.x += 1.0
	if Input.is_action_pressed("move_up"):
		movementVector.y -= 1.0
	if Input.is_action_pressed("move_down"):
		movementVector.y += 1.0
	
	if movementVector.y < 0:
		sprite.play("walk_back")
	elif movementVector.y > 0:
		sprite.play("walk_front")
	elif movementVector.x > 0:
		sprite.play("walk_right")
	elif movementVector.x < 0:
		sprite.play("walk_left")
	elif movementVector.x == 0 && movementVector.y == 0 && sprite.animation == "walk_back":
		sprite.play("default_back")
	elif movementVector.x == 0 && movementVector.y == 0 && sprite.animation == "walk_front":
		sprite.play("default")
	elif movementVector.x == 0 && movementVector.y == 0 && sprite.animation == "walk_left":
		sprite.play("default_left")
	elif movementVector.x == 0 && movementVector.y == 0 && sprite.animation == "walk_right":
		sprite.play("default_right")
	
	var normalizedDelta = movementVector.normalized()
	var newPos = self.position + normalizedDelta * moveSpeed
	newPos.x = clamp(newPos.x, 0, 640)
	newPos.y = clamp(newPos.y, 0, 480)
	if isPossiblePosition(newPos):
		self.position = newPos 
	
	pass

func isPossiblePosition(newPos):
	if isInFusionatorArea(newPos) || isInPressurinatorArea(newPos) || isInOverViewArea(newPos) || isInPipeLeftArea(newPos) || isInPipeRightArea(newPos) || isInChuteTopArea(newPos) || isInChuteBottomArea(newPos): 
		return false
	return true
	
onready var fusWalkArea = $"../Fusionator/MoveBlockArea/CollisionShape2D"
func isInFusionatorArea(newPos):
	return Util.isInCollisionShapeRect(fusWalkArea, newPos)
	
onready var pressWalkArea = $"../Pressurinator/MoveBlockArea/CollisionShape2D"
func isInPressurinatorArea(newPos):
	return Util.isInCollisionShapeRect(pressWalkArea, newPos)

onready var overWalkArea = $"../Overview/MoveBlockArea/CollisionShape2D"
func isInOverViewArea(newPos):
	return Util.isInCollisionShapeRect(overWalkArea, newPos)
	
onready var pipeLeftWalkArea = $"../PipeLeft/MoveBlockArea/CollisionShape2D"
func isInPipeLeftArea(newPos):
	return Util.isInCollisionShapeRect(pipeLeftWalkArea, newPos)
	
onready var pipeRightWalkArea = $"../PipeRight/MoveBlockArea/CollisionShape2D"
func isInPipeRightArea(newPos):
	return Util.isInCollisionShapeRect(pipeRightWalkArea, newPos)

onready var chuteTopWalkArea = $"../ChuteTop/MoveBlockArea/CollisionShape2D"
func isInChuteTopArea(newPos):
	return Util.isInCollisionShapeRect(chuteTopWalkArea, newPos)

onready var chuteBottomWalkArea = $"../ChuteBottom/MoveBlockArea/CollisionShape2D"
func isInChuteBottomArea(newPos):
	return Util.isInCollisionShapeRect(chuteBottomWalkArea, newPos)

