extends ColorRect
@onready var roaetext := $Roae
@onready var buttonbox := $VBoxContainer
@onready var tween := $Tween
@onready var White := $Flash
@onready var audio := $AudioStreamPlayer2D
@onready var blinking_text := $AnyB

var blink_tween = Tween
var is_waiting_for_input := true

func _ready():
	MusicManager.play_music("menu")
	roaetext.modulate.a = 1.0
	buttonbox.modulate.a = 0.0
	White.modulate.a = 0.0
	blinking()
	
func blinking():
	
	# Create new tween for blinking effect
	blink_tween = create_tween()
	blink_tween.set_loops() # Infinite loop
	
	# Fade out to 0 alpha over 0.5 seconds, then fade in over 0.5 seconds
	blink_tween.tween_property(blinking_text, "modulate:a", 0.0, 1.0)
	blink_tween.tween_property(blinking_text, "modulate:a", 1.0, 1.0)

# Fades in menu buttons
func fade_in_menu_buttons():
	var tween = create_tween()
	tween.tween_property(buttonbox, "modulate:a", 1.0, 3.0)
	await tween.finished

# Flashes the screen white
func flash_of_white():
	var flashtween = create_tween()
	# Fix: Properly set the alpha to 1.0
	White.modulate = Color(White.modulate.r, White.modulate.g, White.modulate.b, 1.0)
	# Make sure it's visible
	White.visible = true
	flashtween.tween_property(White, "modulate:a", 0.0, 2.0)
	# hides it when done
	flashtween.tween_callback(func(): White.visible = false)

func turn_text_red():
	roaetext.modulate = Color("#ff0000")

func play_sound():
	audio.play()


func _input(event):
	# Check if we're still waiting for input
	if not is_waiting_for_input:
		return
	# Check for any key press or mouse click
	if event is InputEventKey and event.pressed: # keyboard 
		is_waiting_for_input = false #makes it so they can only click it once
		if blink_tween: # Kills the blinking text when the button is pressed
			blink_tween.kill()
		blinking_text.visible = false # hides it
		play_sound()
		flash_of_white()
		turn_text_red()
		fade_in_menu_buttons()

	elif event is InputEventMouseButton and event.pressed: #mouse
		is_waiting_for_input = false 
		if blink_tween:
			blink_tween.kill()
		blinking_text.visible = false
		play_sound()
		flash_of_white()
		turn_text_red()
		fade_in_menu_buttons()
