extends CanvasLayer

var enabled=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if(Input.is_action_just_pressed("Pause") and not enabled):
		enabled=true
		get_tree().paused=true
		$Time.text="Time: " + str(round(GameManager.levelNode.runtime*10)/10) + "s"
		$Detections.text="Detections: " + str(GameManager.levelNode.encounters)
		$Controller.play("appear")
	elif(Input.is_action_just_pressed("Pause") and enabled):
		get_tree().paused=false
		enabled=false
		$Controller.play("begone")


func _on_restart_pressed() -> void:
	get_tree().paused=false
	get_tree().change_scene_to_file("res://Scenes/Levels/level" + str(GameManager.level+1) + ".tscn")


func _on_resume_pressed() -> void:
	get_tree().paused=false
	$Controller.play("begone")


func _on_menu_pressed() -> void:
	get_tree().paused=false
	Music.menu()
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
