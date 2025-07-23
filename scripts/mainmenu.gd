extends ColorRect
@onready var tween = $Tween

func _ready():
	MusicManager.play_music("menu")
	$VBoxContainer.modulate.a = 0.0
	fade_in_menu_buttons()
	
# Doing this for now, soon add a click any button functionality 
func fade_in_menu_buttons():
	var tween = create_tween()
	tween.tween_property($VBoxContainer, "modulate:a", 1.0, 10.0)
	await tween.finished
	
	
	
	
