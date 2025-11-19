extends AnimatedSprite2D

var placed=false
var collided:=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if(Input.is_action_just_pressed("Interact") and collided):
		if(not placed):
			$Gifts.visible=true
			$AnimationPlayer.play("unoutline")
			placed=true
			GameManager.placed=true


func _on_area_2d_body_entered(body: Node2D) -> void:
	if(body is Player and not placed):
		$AnimationPlayer.play("outline")
		collided=true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if(body is Player):
		$AnimationPlayer.play("unoutline")
		collided=false
