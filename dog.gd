extends CharacterBody2D

var movementBounds = 500.0;
var startingX = 0.0;
var patrolDirection=-1

@export var speed:=1.0

var sprite: AnimatedSprite2D
var idleTime:=0.0
var sittingTime:=0.0

var chasing=false

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

func _process(delta: float) -> void:
	match currentState:
		state.IDLE:
			if(sprite.animation!="idle"):
				sprite.play("idle")
				idleTime=0
			idleTime+=delta
			if(chasing and abs(global_position.x-GameManager.player.global_position.x)>=150):
				currentState=state.CHASING
			if(idleTime>1):
				currentState=state.SITTING
		state.SITTING:
			if(sprite.animation!="sit"):
				sprite.play("sit")
			if(chasing and abs(global_position.x-GameManager.player.global_position.x)>=150):
				currentState=state.CHASING
		state.PATROLLING:
			if(sprite.animation!="walk"):
				sprite.play("walk")
			if(patrolDirection<0):
				if(startingX-movementBounds < position.x):
					position.x-=speed*delta
					sprite.flip_h=true
				else:
					patrolDirection*=-1
			else:
				if(startingX+movementBounds > position.x):
					position.x+=speed*delta
					sprite.flip_h=false
				else:
					patrolDirection*=-1
			if visible and (abs(global_position.distance_to(GameManager.player.global_position)) <=400):
				currentState=state.CHASING
		state.CHASING:
			chasing=true
			if(sprite.animation!="walk"):
				sprite.play("walk")
			if(global_position.x-GameManager.player.global_position.x>0):
				position.x-=speed*delta*1.4
				sprite.flip_h=true
			elif(global_position.x-GameManager.player.global_position.x < 0):
				position.x+=speed*delta*1.4
				sprite.flip_h=false
			if !visible or (abs(global_position.distance_to(GameManager.player.global_position)) >=400):
				chasing=false
				currentState=state.PATROLLING
			if(abs(global_position.x-GameManager.player.global_position.x))<=150:
				currentState=state.IDLE

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
