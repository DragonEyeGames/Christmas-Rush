extends Button

@export var level:=0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$RichTextLabel.text = 'Level ' + str(level+1)
	$Star/Filled.visible=GameManager.stars[level]>=1
	$Star2/Filled.visible=GameManager.stars[level]>=2
	$Star3/Filled.visible=GameManager.stars[level]>=3
	if(GameManager.unlockedLevel<level):
		$Lock.visible=true
		$".".disabled=true
		$ColorRect.color.a=0.5
	else:
		$ColorRect.color.a=0.2


func _on_pressed() -> void:
	Music.main()
	var levelToChange:="res://Scenes/Levels/level" + str(level+1) + ".tscn"
	GameManager.level=level
	get_tree().change_scene_to_file(levelToChange)


func _on_mouse_entered() -> void:
	var tween=create_tween()
	tween.tween_property(self, "scale", Vector2(1.1, 1.1), .1)


func _on_mouse_exited() -> void:
	var tween=create_tween()
	tween.tween_property(self, "scale", Vector2(1, 1), .1)
