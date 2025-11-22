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
@export var door:Node2D

var patrolDirection:=1

func _ready() -> void:
	visible=false
	startingX=position.x
	sprite=$AnimatedSprite2D
	leftPos=$Left.global_position.x
	rightPos=$Right.global_position.x
	self.global_position.x=door.global_position.x

func activate():
	if(active==false):
		active=true
		door.open()
		if(sprite.animation!="walk"):
			sprite.play("walk")

func _process(delta: float) -> void:
	if(active):
		if(visible==false):
			sprite.modulate.a=0
			visible=true
		else:
			sprite.modulate.a=1
		if(patrolDirection==-1):
			if(leftPos < global_position.x):
				position.x-=speed*delta
				sprite.scale.x=-abs(sprite.scale.x)
			else:
				patrolDirection=0
				sprite.play("idle")
				await get_tree().create_timer(.7).timeout
				sprite.play("walk")
				patrolDirection=1
				var tween=create_tween()
				tween.tween_property($PointLight2D, "scale:y", abs($PointLight2D.scale.y), .4)
		elif(patrolDirection==1):
			if(rightPos > global_position.x):
				position.x+=speed*delta
				sprite.scale.x=abs(sprite.scale.x)
			else:
				patrolDirection=0
				sprite.play("idle")
				await get_tree().create_timer(.7).timeout
				sprite.play("walk")
				patrolDirection=-1
				var tween=create_tween()
				tween.tween_property($PointLight2D, "scale:y", -abs($PointLight2D.scale.y), .4 )
	else:
		if(sprite.animation!="idle"):
			sprite.play("idle")
		visible=false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if(visible and body is Player and GameManager.player.concealed==false):
		print("I got you now")
