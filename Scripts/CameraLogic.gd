extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var isSwerving = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	updateCameraPosition(delta)
	pass

onready var player = $"../Player"
func updateCameraPosition(delta):
	if !isSwerving:
		updateCameraPositionPlayer()
	else:
		updateSwerveTo(delta)
	pass

func updateCameraPositionPlayer():
	var playerRelativePos = player.position - self.position
	var borderX = 160
	var borderY = 120
	var deltaMove = Vector2(0,0)
	if playerRelativePos.x < borderX:
		deltaMove.x = playerRelativePos.x - borderX
		pass
	if playerRelativePos.x > (320 - borderX):
		deltaMove.x = playerRelativePos.x - (320 - borderX)
		pass
	if playerRelativePos.y < borderY:
		deltaMove.y = playerRelativePos.y - borderY
		pass
	if playerRelativePos.y > (240 - borderY):
		deltaMove.y = playerRelativePos.y - (240 - borderY)
		pass
		
	self.position += deltaMove
	#self.position.x = clamp(self.position.x, 0, 320)
	#self.position.y = clamp(self.position.y, 0, 240)
	pass

var targetPos
var wasTargetReached
func swerveToPos(newPos):
	wasTargetReached = false
	targetPos = newPos
	isSwerving = true
	pass

var swerveWaitLeft = 0.0
func updateSwerveTo(delta):
	if swerveWaitLeft > 0.0:
		swerveWaitLeft -= delta
		return
		
	var speed = 200
	var target	
	if wasTargetReached:
		target = player.position - Vector2(160, 120)
	else:
		target = targetPos
		
	var deltaPos = (target - self.position)
	if deltaPos.length() < speed * delta:
		self.position = target
		if wasTargetReached == false:
			wasTargetReached = true
			swerveWaitLeft = 3.0
		else:
			isSwerving = false
		pass
	else:
		self.position += deltaPos.normalized() * speed * delta
		
	pass
