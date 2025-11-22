extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.camera=self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if(GameManager.cameraFollow!=null):
		global_position = GameManager.cameraFollow.global_position
