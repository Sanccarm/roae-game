extends CanvasLayer

func _ready():
	# Connect to scene changes
	Dialogic.signal_event.connect(_on_dialogic_event)
	get_tree().connect("scene_changed", _on_scene_changed)
	_check_current_scene()

func _on_scene_changed():
	_check_current_scene()

func _check_current_scene():
	var current_scene = get_tree().current_scene
	var scene_name = current_scene.scene_file_path.get_file().get_basename()
	
	# Hide UI on specific scenes
	if scene_name in ["MainMenu", "Saves", "CharacterCreation"]:
		hide()
	else:
		show()

func _on_dialogic_event(resource):
	if resource is DialogicTextEvent:
		# Use your custom textbox instead of default
		$DialogueBox.text = resource.text
