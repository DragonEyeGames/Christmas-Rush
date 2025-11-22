extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func main():
	var tween = create_tween()
	tween.tween_property($Main, "volume_db", -5, .5)
	var tween2 = create_tween()
	tween2.tween_property($Menu, "volume_db", -80, .5)
	
func menu():
	var tween = create_tween()
	tween.tween_property($Main, "volume_db", -80, .5)
	var tween2 = create_tween()
	tween2.tween_property($Menu, "volume_db", 0, .5)
