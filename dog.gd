extends CharacterBody2D

var movementBounds = 500.0;
var startingX = 0.0;
var patrolDirection=-1

@export var speed:=1.0

var sprite: AnimatedSprite2D

enum state {
	IDLE,
	SITTING,
	WALKING,
	PATROLLING
}

var currentState: state = state.PATROLLING

func _ready() -> void:
	startingX=position.x
	sprite=$Sprite

func _process(_delta: float) -> void:
	print(state)
	match currentState:
		state.IDLE:
			pass
		state.SITTING:
			pass
		state.WALKING:
			pass
		state.PATROLLING:
			print("neyroom")
			if(patrolDirection<0):
				if(startingX-movementBounds < position.x):
					position.x-=speed
					sprite.flip_h=true
				else:
					patrolDirection*=-1
			else:
				if(startingX+movementBounds > position.x):
					position.x+=speed
					sprite.flip_h=false
				else:
					patrolDirection*=-1

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
