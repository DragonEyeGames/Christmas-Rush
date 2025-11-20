extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(GameManager.stars[0]>0):
		if(GameManager.stars[0]>=1):
			$Level1/Star/Filled.visible=true
		if(GameManager.stars[0]>=2):
			$Level1/Star2/Filled.visible=true
		if(GameManager.stars[0]>=3):
			$Level1/Star3/Filled.visible=true


func _on_level_1_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/Level1.tscn")
