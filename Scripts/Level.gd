extends Node2D
class_name Level
@export var minScore:=100
@export var medScore:=300
@export var maxScore:=500

@export var parTime:=10.0
@export var minTime:=45.0
@export var parDetections:=1
@export var timeMultiplier:=1.0
@export var christmasTrees=1

@export var panObject: Array[Node2D]=[]

var runtime:=0.0
var encounters:=0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.levelNode=self
	await get_tree().process_frame
	GameManager.player.canMove=false
	await get_tree().create_timer(1.1).timeout
	for node in panObject:
		var nodeVisible=node.visible
		node.visible=true
		GameManager.camera.position_smoothing_enabled=false
		GameManager.cameraFollow=node
		await get_tree().create_timer(1.1).timeout
		if(not nodeVisible):
			node.visible=false
	GameManager.cameraFollow=GameManager.playerNode
	await get_tree().process_frame
	await get_tree().process_frame
	GameManager.player.canMove=true
	GameManager.camera.position_smoothing_enabled=true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	runtime+=delta
	
