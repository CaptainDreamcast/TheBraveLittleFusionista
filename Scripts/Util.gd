extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func isInCollisionShapeRect(node, testPos):
	var extents = node.shape.extents
	var pos = node.get_global_position() - Vector2(extents.x, extents.y)
	var rect = Rect2(pos, extents * 2 * 1.01);
	return rect.has_point(testPos)

onready var standaloneSFXPrefab = preload("res://Prefabs/StandaloneSFX.tscn")
func playSoundEffect(preloadedSoundStream):
	var newSFX = standaloneSFXPrefab.instance()
	newSFX.stream = preloadedSoundStream
	self.add_child(newSFX)
	pass
