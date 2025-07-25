extends Button

func _ready() -> void:
	if len(GameManager.get_all_saves()) == 0:
		disabled = true
	else:
		disabled = false
		#SceneManager.fade_to_scene("res://scenes/saves.tscn")
	pass
