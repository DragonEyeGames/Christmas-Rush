extends CharacterBody2D
class_name Player

const SPEED = 150.0
const JUMP_VELOCITY = -300.0
var coyoteTimer=0.0
var coyoteTime=0.3

var concealed=false
var canMove=true

var lightColliding=[]

func _ready() -> void:
	GameManager.player=self
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
	
	move_and_slide()
	lightVisibility()

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
