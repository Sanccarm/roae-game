extends Button

func _ready() -> void:
	pressed.connect(_on_button_pressed)
	
func _on_button_pressed():
	SceneManager.fade_to_scene("res://scenes/CharacterCreation.tscn")
