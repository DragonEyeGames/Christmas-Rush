extends CharacterBody2D

var movementBounds = 500.0;
var startingX = 0.0;
var patrolDirection=1
@export var scaleDifference:=1.0
@export var speedDifference:=1.0
@export var speed:=1.0
var leftPos:=0.0
var rightPos:=0.0
var sprite: AnimatedSprite2D
var idleTime:=0.0
var sittingTime:=0.0
var detectionTime:=0.0
var chasing=false

@export var human:Human

enum state {
	IDLE,
	SITTING,
	PATROLLING,
	CHASING
}

var currentState: state = state.PATROLLING

func _ready() -> void:
	startingX=position.x
	sprite=$Sprite
	leftPos=$Left.global_position.x
	rightPos=$Right.global_position.x
	visible=false

func _process(delta: float) -> void:
	if(chasing and GameManager.player.concealed):
		chasing=false
	match currentState:
		state.IDLE:
			if(sprite.animation!="idle"):
				sprite.play("idle")
				idleTime=0
			idleTime+=delta
			if(chasing and abs(global_position.x-GameManager.player.global_position.x)>=150*scaleDifference and GameManager.player.concealed==false):
				currentState=state.CHASING
			if(idleTime>1):
				currentState=state.SITTING
				idleTime=0
		state.SITTING:
			if(sprite.animation!="sit"):
				sprite.play("sit")
			if(chasing and abs(global_position.x-GameManager.player.global_position.x)>=150*scaleDifference and GameManager.player.concealed==false):
				currentState=state.CHASING
			sittingTime+=delta
			if(sittingTime>3 and not chasing):
				currentState=state.PATROLLING
				sittingTime=0
		state.PATROLLING:
			if(sprite.animation!="walk"):
				sprite.play("walk")
			if(patrolDirection<0):
				if(leftPos < global_position.x):
					position.x-=speed*delta*speedDifference
					sprite.flip_h=true
				else:
					patrolDirection*=-1
			else:
				if(rightPos > global_position.x):
					position.x+=speed*delta*speedDifference
					sprite.flip_h=false
				else:
					patrolDirection*=-1
			if visible and (abs(global_position.distance_to(GameManager.player.global_position)) <=400*scaleDifference and GameManager.player.concealed==false) and ((GameManager.player.global_position.x<global_position.x and patrolDirection<0) or (GameManager.player.global_position.x>global_position.x and patrolDirection>0)):
				detectionTime+=delta
				if(detectionTime>0.5):
					detectionTime=0
					GameManager.levelNode.encounters+=1
					currentState=state.CHASING
					$bark.play()
					await get_tree().create_timer(.5).timeout
					GameManager.cameraFollow=human
					await get_tree().create_timer(.7).timeout
					human.activate()
					await get_tree().create_timer(2).timeout
					GameManager.cameraFollow=GameManager.player
		state.CHASING:
			chasing=true
			if(randi_range(0, 69)==67):
				$bark.play()
			if(sprite.animation!="walk"):
				sprite.play("walk")
			if(global_position.x-GameManager.player.global_position.x>0):
				position.x-=speed*delta*2*speedDifference
				patrolDirection=-1
				sprite.flip_h=true
			elif(global_position.x-GameManager.player.global_position.x < 0):
				position.x+=speed*delta*2*speedDifference
				patrolDirection=1
				sprite.flip_h=false
			if !visible or (abs(global_position.distance_to(GameManager.player.global_position)) >=400*scaleDifference):
				chasing=false
				currentState=state.PATROLLING
			if(abs(global_position.x-GameManager.player.global_position.x))<=150*scaleDifference:
				currentState=state.IDLE
			if(GameManager.player.concealed):
				chasing=false
				currentState=state.PATROLLING

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.

	move_and_slide()
