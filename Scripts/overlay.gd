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
	var time:float =(round(level.runtime*100)/100)
	var score:=0
	var timeBonus=(((time-level.parTime)/(level.minTime-level.parTime)))
	var detectionSubtraction=min(0, level.encounters-1)*100
	score+=int((1.0-timeBonus)*level.timeMultiplier)
	score-=detectionSubtraction
	$Score.text="Score: " + str(score)
	if(GameManager.unlockedLevel<GameManager.level+1):
		GameManager.unlockedLevel=GameManager.level+1
	var visibleStars:=0
	
	await get_tree().create_timer(.8).timeout
	if(score>=level.minScore):
		visibleStars+=1
		$Stars/Star/Show.play("show")
	await get_tree().create_timer(.4).timeout
	if(score>=level.medScore):
		visibleStars+=1
		$Stars/Star2/Show.play("show")
	await get_tree().create_timer(.4).timeout
	if(score>=level.maxScore):
		visibleStars+=1
		$Stars/Star3/Show.play("show")
	if(visibleStars>GameManager.stars[GameManager.level]):
		GameManager.stars[GameManager.level]=visibleStars
	var save = SaveData.new()
	save.stars=GameManager.stars
	save.unlockedLevel=GameManager.unlockedLevel
	save.writeSave()
		
	


func _on_restart_pressed() -> void:
	GameManager.placed=false
	get_tree().paused=false
	print(GameManager.level)
	get_tree().change_scene_to_file("res://Scenes/Levels/Level" + str(GameManager.level+1) + ".tscn")


func _on_menu_pressed() -> void:
	Music.menu()
	GameManager.placed=false
	get_tree().paused=false
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
