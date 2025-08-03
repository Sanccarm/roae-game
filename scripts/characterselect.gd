extends ColorRect
@onready var lightning := $Flash
@onready var flash_timer := Timer.new()
@onready var thunderaudio := $AudioStreamPlayer2D
@onready var rainaudio := $AudioStreamPlayer2D2
@onready var varpanel := $Panel
@onready var name_input := $Panel/Nameinput  # Adjust path as needed
@onready var blood_input := $Panel/Bloodtypeinput  # Adjust path as needed
@onready var blessing_input := $Panel/Blessinginput  # Adjust path as needed
@onready var create_button := $Panel/Accept  # Adjust path as needed
@onready var error_label := $Panel/Errorlabel 
@onready var character_panel := $CharacterPanel
@onready var character_panel_button := $Panel/OpenCharacters
@onready var character_group = ButtonGroup.new()

@onready var option1 := $CharacterPanel/Option1 #white
@onready var option2 := $CharacterPanel/Option2 #black
@onready var option3 := $CharacterPanel/Option3 #white fem
@onready var option4 := $CharacterPanel/Option4 #black fem

var valid_blood_types := ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"]

var player_sprite := ""  # Store the selected sprite path

func _ready():
	# Setup button group
	option1.toggle_mode = true
	option2.toggle_mode = true
	option3.toggle_mode = true
	option4.toggle_mode = true
	
	option1.button_group = character_group
	option2.button_group = character_group
	option3.button_group = character_group
	option4.button_group = character_group
	
	# Connect character selection signals
	option1.toggled.connect(_on_option_1_toggled)
	option2.toggled.connect(_on_option_2_toggled)
	option3.toggled.connect(_on_option_3_toggled)
	option4.toggled.connect(_on_option_4_toggled)

	gui.hide()
	character_panel.visible = false
	character_panel.position.x = 1153.0
	lightning.modulate.a = 0.0
	varpanel.modulate.a = 0.0
	lightning.visible = false
	
	if error_label:
		error_label.visible = false
	
	await get_tree().create_timer(1.0).timeout
	var tween = create_tween()
	tween.tween_property(varpanel, "modulate:a", 1.0, 5.0)
	rainaudio.play()
	
	add_child(flash_timer)
	flash_timer.wait_time = 2.5  # Check every 2.5 seconds
	flash_timer.timeout.connect(_on_flash_timer_timeout)
	flash_timer.start()
	
	if create_button:
		create_button.pressed.connect(_on_create_button_pressed)

func _on_flash_timer_timeout():
	var i := randi_range(1, 100)
	if i <= 15:  # 15% chance each check
		flash_lightning()

func play_sound():
	thunderaudio.play()

func flash_lightning():
	# Don't flash if already flashing
	if lightning.visible:
		return
	play_sound()
	lightning.visible = true
	lightning.modulate.a = 1.0
	
	var flash_tween = create_tween()
	flash_tween.tween_property(lightning, "modulate:a", 0.0, 2.0)
	flash_tween.finished.connect(func(): lightning.visible = false)

func _on_open_characters_toggled(toggled_on: bool) -> void:
	character_panel.visible = true 
	var panel_tween_open = get_tree().create_tween()
	var panel_tween_close = get_tree().create_tween()
	if character_panel_button.button_pressed == true:
		if panel_tween_close:
			panel_tween_close.stop()
		panel_tween_open.tween_property(character_panel, "position:x", 967.0, 0.20)
		
	if character_panel_button.button_pressed == false:
		if panel_tween_open:
			panel_tween_open.stop()
		await panel_tween_close.tween_property(character_panel, "position:x", 1153.0, 0.20)
		#character_panel.visible = false

# Updated character selection functions that save the sprite
func _on_option_1_toggled(is_pressed: bool) -> void:
	if is_pressed:
		character_panel_button.text = "Option 1"
		player_sprite = "res://assets/faces/playerfaces/White-Male-Player-Blacked.png"
		hide_error()  # Clear any selection errors

func _on_option_2_toggled(is_pressed: bool) -> void:
	if is_pressed:
		character_panel_button.text = "Option 2"
		player_sprite = "res://assets/faces/playerfaces/Black-Male-Player-Blacked.png"
		hide_error()

func _on_option_3_toggled(is_pressed: bool) -> void:
	if is_pressed:
		character_panel_button.text = "Option 3"
		player_sprite = "res://assets/faces/playerfaces/White-Female-Player-Blacked.png"
		hide_error()

func _on_option_4_toggled(is_pressed: bool) -> void:
	if is_pressed:
		character_panel_button.text = "Option 4"
		player_sprite = "res://assets/faces/playerfaces/Black-Female-Player-Blacked.png"
		hide_error()

func validate_character_selection() -> bool:
	var selected_button = character_group.get_pressed_button()
	
	if selected_button == null:
		show_error("Please select a character before continuing.")
		return false
	else:
		return true

func get_player_sprite() -> String:
	return player_sprite

# -------------------- Code for name validation, blood type validation, --------------------
# Validation functions
func validate_name(name: String) -> String:
	# Remove leading/trailing whitespace
	name = name.strip_edges()
	
	# Check length
	if name.length() < 2:
		return "Name must be at least 2 characters long"
	if name.length() > 20:
		return "Name must be no more than 20 characters long"
	
	# Check for only letters and spaces
	var regex = RegEx.new()
	regex.compile("^[A-Za-z ]+$")
	if not regex.search(name):
		return "Name can only contain letters and spaces"
	
	return ""  # Empty string means valid

func validate_blood_type(blood: String) -> String:
	# Remove whitespace and convert to uppercase
	blood = blood.strip_edges().to_upper()
	
	# Check if it's a valid blood type
	if not blood in valid_blood_types:
		return "Invalid blood type. Valid options are: " + ", ".join(valid_blood_types)
	
	return ""  # Empty string means valid

func validate_blessing(blessing: String) -> String:
	# Remove leading/trailing whitespace
	blessing = blessing.strip_edges()
	
	# Check character count
	if blessing.length() < 3:
		return "Blessing must be at least 3 characters long"
	if blessing.length() > 20:
		return "Blessing must be no more than 20 characters long"
	
	return ""  # Empty string means valid

func show_error(message: String):
	if error_label:
		error_label.text = message
		error_label.visible = true
		error_label.modulate = Color.RED

func hide_error():
	if error_label:
		error_label.text = ""
		error_label.visible = false

func _on_create_button_pressed():
	# Get input values
	var player_name = name_input.text if name_input else ""
	var player_blood = blood_input.text if blood_input else ""
	var player_blessing = blessing_input.text if blessing_input else ""

	# Validate each input
	var name_error = validate_name(player_name)
	var blood_error = validate_blood_type(player_blood)
	var blessing_error = validate_blessing(player_blessing)
	var character_valid = validate_character_selection()  # Returns bool now
	
	# Check for errors
	if name_error != "":
		show_error("Name Error: " + name_error)
		return
	
	if blood_error != "":
		show_error("Blood Type Error: " + blood_error)
		return
	
	if blessing_error != "":
		show_error("Blessing Error: " + blessing_error)
		return
	
	if not character_valid:
		# Error message already shown by validate_character_selection()
		return
	
	# All validation passed - save the data
	save_character_data(player_name, player_blood, player_blessing, player_sprite)

func save_character_data(name: String, blood: String, blessing: String, sprite: String):
	# Clean the data
	name = name.strip_edges()
	blood = blood.strip_edges().to_upper()
	blessing = blessing.strip_edges()
	
	# Set data in GameManager (adjust these calls to match your GameManager)
	GameManager.set_player_name(name)
	GameManager.player_blood = blood
	GameManager.player_blessing = blessing
	GameManager.player_sprite = sprite  # Save the sprite path
	
	# Save the game data
	var success = GameManager.save_game_data({
		"character_created": true,
		"creation_date": Time.get_datetime_string_from_system()
	})
	
	if success:
		print("Character created successfully!")
		print("Name: ", name)
		print("Blood Type: ", blood)
		print("Blessing: ", blessing)
		print("Sprite: ", sprite)
		
		# Change to next scene - replace with your actual next scene
		MusicManager.stop_music()
		SceneManager.fade_to_scene("res://scenes/Cutscene.tscn")
	else:
		show_error("Failed to save character data. Please try again.")

# Optional: Add real-time validation feedback
func _on_blood_input_text_changed(new_text: String):
	var error = validate_blood_type(new_text)
	if error != "" and new_text.length() > 0:
		# Could show inline error feedback here
		pass

func _on_blessing_input_text_changed(new_text: String):
	var error = validate_blessing(new_text)
	if error != "" and new_text.length() > 0:
		# Could show inline error feedback here
		pass
