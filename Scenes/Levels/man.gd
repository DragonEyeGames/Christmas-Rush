extends CharacterBody2D
class_name Human

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var leftPos:=0.0
var rightPos:=0.0
var sprite
var startingX
@export var speed:=1.0
var active=false

var patrolDirection:=1

func _ready() -> void:
	visible=false
	startingX=position.x
	sprite=$AnimatedSprite2D
	leftPos=$Left.global_position.x
	rightPos=$Right.global_position.x
func activate():
	if(active==false):
		active=true

func _process(delta: float) -> void:
	if(active):
		if(sprite.animation!="walk"):
			sprite.play("walk")
		visible=true
		if(patrolDirection<0):
			if(leftPos < global_position.x):
				position.x-=speed*delta
				sprite.scale.x=-abs(sprite.scale.x)
				$PointLight2D.scale.y=-abs($PointLight2D.scale.y)
			else:
				patrolDirection*=-1
		else:
			if(rightPos > global_position.x):
				position.x+=speed*delta
				sprite.scale.x=abs(sprite.scale.x)
				$PointLight2D.scale.y=abs($PointLight2D.scale.y)
			else:
				patrolDirection*=-1
	else:
		if(sprite.animation!="idle"):
			sprite.play("idle")
		visible=false
