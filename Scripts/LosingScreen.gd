extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var BGM = $BGM
onready var jingle = preload("res://Sounds/game_over_jingle1.wav")
onready var sprite = $AnimatedSprite
# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.play("default")
	pass # Replace with function body.

var gameTime = 0.0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	gameTime += delta
	
	if gameTime > 2.0 && sprite.animation == "default":
		sprite.play("2")
		BGM.stream = jingle
		BGM.play()
	if gameTime > 3.0 && sprite.animation == "2":
		sprite.play("3")
		
	if Input.is_action_just_pressed("losing_screen_restart"):
		var _changed = get_tree().change_scene("res://Screens/MainGameScreen.tscn");
	pass
