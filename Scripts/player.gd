extends CharacterBody2D
class_name Player

const SPEED = 150.0
const JUMP_VELOCITY = -300.0
var coyoteTimer=0.0
var coyoteTime=0.3

var moving=0
#0=standard
#1=pushing
#2=pulling

var concealed=false
var canMove=true
var sprite
var lightColliding=[]

func _ready() -> void:
	GameManager.player=self
	GameManager.cameraFollow=$Node2D
	sprite=$sprite
	GameManager.playerNode=GameManager.cameraFollow

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		coyoteTimer+=delta
		velocity += get_gravity() * delta
	else:
		coyoteTimer=0

	if(canMove):
		# Handle jump.
		if Input.is_action_just_pressed("Jump") and (is_on_floor() or coyoteTimer<coyoteTime):
			velocity.y = JUMP_VELOCITY

		var direction := Input.get_axis("Left", "Right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			
		if(Input.is_action_pressed("Sprint")):
			velocity.x*=1.5
	else:
		velocity.x=move_toward(velocity.x, 0, delta*10000)
	
	if(abs(velocity.x)<0.1):
		velocity.x=0
	if(abs(velocity.y)<0.1):
		velocity.y=0
	move_and_slide()
	lightVisibility()
	if(moving==0):
		if(abs(velocity.x)>1 and sprite.animation!="walk"):
			sprite.play("walk")
		if(velocity==Vector2.ZERO and sprite.animation!="idle"):
			sprite.play("idle")
		if(velocity.y<-1 and sprite.animation!="jumpRise"):
			sprite.play("jumpRise")
		if(velocity.y>1 and sprite.animation!="jumpFall"):
			sprite.play("jumpFall")
	if(velocity.x<0):
		sprite.flip_h=true
	elif(velocity.x>0):
		sprite.flip_h=false
	if(moving==1):
		sprite.flip_h=false
		if(velocity.x>0 and not sprite.animation=="push"):
			sprite.play("push")
		elif(velocity.x<0 and not sprite.animation=="pull"):
			sprite.play("pull")
	if(moving==-1):
		sprite.flip_h=true
		if(velocity.x<0 and not sprite.animation=="push"):
			sprite.play("push")
		elif(velocity.x>0 and not sprite.animation=="pull"):
			sprite.play("pull")

func lightVisibility():
	for item in lightColliding:
		$RayCast2D.target_position = to_local(item.global_position)
		$RayCast2D.force_raycast_update()
		if($RayCast2D.is_colliding()):
			item.visible=false
		else:
			item.visible=true

func _light_entered(area: Area2D) -> void:
	lightColliding.append(area.get_parent())


func _light_exited(area: Area2D) -> void:
	if(area.get_parent() in lightColliding):
		lightColliding.erase(area.get_parent())
		area.get_parent().visible=false
		
func reparentCamera():
	var cameraNode = $Node2D
	var globalPosition=cameraNode.global_position
	remove_child(cameraNode)
	get_parent().add_child(cameraNode)
	cameraNode.global_position=globalPosition
