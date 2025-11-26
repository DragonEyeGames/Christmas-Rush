extends Node2D

var colliding=false
@export var door: Node2D
var dragging:=0
var originalParent
var unblock=null
var left
var right
var previousPos=0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(door!=null):
		door.blocked=true
	previousPos=global_position.x


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	print($Scrape.playing)
	if(previousPos!=global_position.x):
		if(not $Scrape.playing):
			$Scrape.play()
	else:
		print("hereserser")
		if($Scrape.playing):
			print("STStosptospt")
			$Scrape.stop()
	previousPos=global_position.x
	if(colliding and Input.is_action_just_pressed("Interact") and dragging==0):
		GameManager.player.canTeleport=false
		var tween = create_tween()
		var direction=1
		if(GameManager.player.global_position.x<self.position.x):
			direction=-1
		dragging=direction
		tween.tween_property(GameManager.player, "global_position:x", global_position.x+(65*direction), .3)
		await get_tree().create_timer(.3).timeout
		await get_tree().process_frame
		GameManager.player.global_position.x = global_position.x+(65*direction)
		GameManager.player.moving=-dragging
		var globalPos=global_position
		var globalScale=global_scale
		originalParent=get_parent()
		get_parent().remove_child(self)
		GameManager.player.add_child(self)
		global_position=globalPos
		global_scale=globalScale
		print($StaticBody2D2.get_children())
		left=$StaticBody2D2.get_child(0)
		var leftPos=left.global_position
		var leftScale=left.global_scale
		$StaticBody2D2.remove_child(left)
		GameManager.player.add_child(left)
		left.global_position=leftPos
		left.global_scale=leftScale
		right=$StaticBody2D2.get_child(0)
		var rightPos=right.global_position
		var rightScale=right.global_scale
		$StaticBody2D2.remove_child(right)
		GameManager.player.add_child(right)
		right.global_position=rightPos
		right.global_scale=rightScale
	elif(dragging!=0 and Input.is_action_just_pressed("Interact")):
		var globalPos=global_position
		var globalScale = global_scale
		GameManager.player.remove_child(self)
		originalParent.add_child(self)
		global_position=globalPos
		global_scale=globalScale
		GameManager.player.moving=0
		dragging=0
		var leftPos=left.global_position
		var leftScale=left.global_scale
		GameManager.player.remove_child(left)
		$StaticBody2D2.add_child(left)
		left.global_position=leftPos
		left.global_scale=leftScale
		var rightPos=right.global_position
		var rightScale=right.global_scale
		GameManager.player.remove_child(right)
		$StaticBody2D2.add_child(right)
		right.global_position=rightPos
		right.global_scale=rightScale
		await get_tree().process_frame
		GameManager.player.canTeleport=true
	if(dragging==0 and unblock!=null):
		await get_tree().process_frame
		if(unblock!=null):
			unblock.blocked=false
			unblock=null
		


func _on_area_2d_body_entered(body: Node2D) -> void:
	if(body is Player):
		colliding=true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if(body is Player):
		colliding=false


func _on_area_2d_area_entered(area: Area2D) -> void:
	area.get_parent().blocked=true


func _on_area_2d_area_exited(area: Area2D) -> void:
	if(dragging==0):
		area.get_parent().blocked=false
	else:
		unblock=area.get_parent()
