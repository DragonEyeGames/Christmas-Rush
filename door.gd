extends Area2D

var colliding:=false
var player
var closed:=false
var moving:=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _input(event: InputEvent) -> void:
	if(event.is_action_pressed("Interact") and colliding and not closed and not moving):
		$Controller.play("concealPlayer")
		var tween = create_tween()
		tween.tween_property(player, "global_position:x", global_position.x, 0.5)
		player.canMove=false
		player.concealed=true
		closed=true
		moving=true
		await get_tree().create_timer(2.2).timeout
		moving=false
	elif(event.is_action_pressed("Interact") and closed and not moving):
		$Controller.play("revealPlayer")
		player.canMove=true
		player.concealed=false
		closed=false
		moving=true
		await get_tree().create_timer(2.2).timeout
		moving=false

func _on_body_entered(body: Node2D) -> void:
	if(body is Player):
		player=body
		colliding=true


func _on_body_exited(body: Node2D) -> void:
	if(body is Player):
		colliding=false
