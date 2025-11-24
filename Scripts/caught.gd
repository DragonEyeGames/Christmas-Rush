extends CanvasLayer

var level:Level

func gameOver():
	level=GameManager.levelNode
	visible=true
	$Controller.play("appear")
	$Stars/Star/MinScore.text=str(level.minScore)
	$Stars/Star2/MinScore.text=str(level.medScore)
	$Stars/Star3/MinScore.text=str(level.maxScore)
	$Time.text="Time: " + str(round(level.runtime*100)/100)
	$Detections.text="Detections: " + str(level.encounters)

func _on_restart_pressed() -> void:
	GameManager.placed=0
	get_tree().paused=false
	get_tree().change_scene_to_file("res://Scenes/Levels/Level" + str(GameManager.level+1) + ".tscn")

func _on_menu_pressed() -> void:
	Music.menu()
	GameManager.placed=0
	get_tree().paused=false
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
