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

var runtime:=0.0
var encounters:=0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.levelNode=self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	runtime+=delta
	
