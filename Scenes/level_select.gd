extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_yes_pressed() -> void:
	var newStars=[]
	for child in $LevelContainer.get_children():
		newStars.append(0)
	var save = SaveData.new()
	save.stars=newStars
	save.unlockedLevel=0
	save.writeSave()
	GameManager.stars=newStars
	GameManager.unlockedLevel=0
	get_tree().change_scene_to_file("res://Scenes/levelSelect.tscn")


func _on_no_pressed() -> void:
	$"Reset Save".visible=false


func _on_reset_button_pressed() -> void:
	$"Reset Save".visible=true
