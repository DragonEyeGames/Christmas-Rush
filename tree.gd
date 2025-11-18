extends AnimatedSprite2D

var placed=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if(Input.is_action_just_pressed("Interact")):
		if(not placed):
			$Gifts.visible=true
			placed=true


func _on_area_2d_body_entered(body: Node2D) -> void:
	if(body is Player and not placed):
		$AnimationPlayer.play("outline")


func _on_area_2d_body_exited(body: Node2D) -> void:
	if(body is Player):
		$AnimationPlayer.play("unoutline")
