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
@export var caughtLayer: CanvasLayer
var patrolDirection:=1

var colliding:=false
var caught:=false
var collidingTime:=0.0
var canMove=true

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
		if(colliding):
			collidingTime+=delta
			if(collidingTime>0.5 and not caught):
				caught=true
				catch(delta)
		if(visible==false):
			sprite.modulate.a=0
			visible=true
		else:
			sprite.modulate.a=1
		if(canMove):
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
		colliding=true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if(visible and body is Player and GameManager.player.concealed==false):
		colliding=false

func catch(_delta: float):
	GameManager.player.canMove=false
	var backupSpeed=speed
	speed=0
	canMove=false
	sprite.play("idle")
	await get_tree().create_timer(.1).timeout
	GameManager.cameraFollow=self
	await get_tree().create_timer(.5).timeout
	$Detected.visible=true
	await get_tree().create_timer(.3).timeout
	$Detected.visible=false
	speed = backupSpeed*1.4
	var tween=create_tween()
	var direction=(GameManager.player.global_position.x - global_position.x)/abs(GameManager.player.global_position.x - global_position.x)
	var time = abs(GameManager.player.global_position.x - global_position.x)/(speed)
	speed=0
	tween.tween_property(self, "global_position:x", GameManager.player.position.x - (direction*50), time)
	await get_tree().create_timer(time+.5).timeout
	get_tree().paused=true
	caughtLayer.gameOver()
	
