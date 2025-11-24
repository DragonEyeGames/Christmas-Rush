extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var save = SaveData.loadSave()
	var levelCount = len(GameManager.stars)
	print(levelCount)
	if(save != null):
		GameManager.stars=save.stars
		GameManager.unlockedLevel=save.unlockedLevel
	var newLevelCount = len(GameManager.stars)
	print(newLevelCount)
	if(levelCount>newLevelCount):
		print("hmmm")
		for level in abs(levelCount-newLevelCount):
			GameManager.stars.append(0)


func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/levelSelect.tscn")
