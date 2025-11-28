extends Area2D
class_name Portal

var playerEntered=false
@export var linkedPortal: Portal
@export var toMove: Node2D
@export var direction:=-1
var blocked=false
@export var tutorial:=false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if(playerEntered and Input.is_action_just_pressed("Interact") and not blocked and GameManager.player.canTeleport):
		await get_tree().process_frame
		if(not GameManager.player.canTeleport):
			return
		GameManager.camera.position_smoothing_enabled=false
		GameManager.player.global_position=linkedPortal.global_position
		if(toMove!=null):
			toMove.global_position=$"Point".global_position
			toMove.patrolDirection=direction
			if(toMove is Human):
				toMove.get_node("PointLight2D").scale.y = abs(toMove.get_node("PointLight2D").scale.y)*direction
		await get_tree().process_frame
		await get_tree().process_frame
		GameManager.camera.position_smoothing_enabled=true
		
		


func _on_body_entered(body: Node2D) -> void:
	if(body is Player):
		playerEntered=true
		if(tutorial):
			$ColorRect.visible=true


func _on_body_exited(body: Node2D) -> void:
	if(body is Player):
		playerEntered=false
		$ColorRect.visible=false
