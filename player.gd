extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var coyoteTimer=0.0
var coyoteTime=0.5


func _physics_process(delta: float) -> void:
	print(coyoteTimer)
	# Add the gravity.
	if not is_on_floor():
		coyoteTimer+=delta
		velocity += get_gravity() * delta
	else:
		coyoteTimer=0

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and (is_on_floor() or coyoteTimer<coyoteTime):
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
