extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -500.0
var coyoteTimer=0.0
var coyoteTime=0.5

var lightColliding=[]

func _physics_process(delta: float) -> void:
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
	lightVisibility()

func lightVisibility():
	for item in lightColliding:
		$RayCast2D.set_deferred("target_position", to_local(item.global_position))
		await get_tree().process_frame
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
