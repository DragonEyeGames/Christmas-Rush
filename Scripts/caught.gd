extends CanvasLayer

var level:Level
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.overlay=self


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
	GameManager.placed=false
	get_tree().paused=false
	get_tree().change_scene_to_file("res://Scenes/Levels/Level" + str(GameManager.level+1) + ".tscn")


func _on_menu_pressed() -> void:
	Music.menu()
	GameManager.placed=false
	get_tree().paused=false
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
