extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var voice = preload("res://Sounds/ending_voice.wav")
onready var audioPlayer = $AudioStreamPlayer
# Called when the node enters the scene tree for the first time.
func _ready():
	audioPlayer.stream = voice
	audioPlayer.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !audioPlayer.playing:
		var _changed = get_tree().change_scene("res://Screens/TitleScreen.tscn");
	pass
