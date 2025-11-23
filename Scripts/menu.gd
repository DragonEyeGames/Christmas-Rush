extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var save = SaveData.loadSave()
	if(save != null):
		print("Hey")
		#GameManager.stars=save.stars
		#GameManager.unlockedLevel=save.unlockedLevel


func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/levelSelect.tscn")
