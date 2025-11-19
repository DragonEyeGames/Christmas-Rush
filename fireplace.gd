extends Node2D

var collided=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if(Input.is_action_just_pressed("Interact")):# and GameManager.placed and collided):
		var tween = create_tween()
		tween.tween_property(GameManager.player, "global_position:x", global_position.x, 0.5)
		await get_tree().create_timer(.5).timeout
		$Bricks2.visible=true
		var tween2=create_tween()
		tween2.tween_property(GameManager.player, "global_position:y", -200, .75)
		await get_tree().create_timer(.75).timeout
		var tween3=create_tween()
		tween3.tween_property(GameManager.player, "global_position:y", -999999, .1)
		await get_tree().create_timer(.1).timeout
		$"../CanvasLayer".visible=true
		get_tree().paused=true
	if($Bricks2.visible and GameManager.player.is_on_floor()):
		$Bricks2.visible=false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if(body is Player and GameManager.placed):
		$Outline.visible=true
		collided=true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if(body is Player):
		$Outline.visible=false
		collided=false
