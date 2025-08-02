extends CanvasLayer
@onready var choice_box = $Ui/MainUI/ChoicesBox
@onready var instructions_label = $Ui/MainUI/ChoicesBox/Instructions  
@onready var objective_box = $Objective
@onready var objective_label = $Objective/ObjectiveLabel
@onready var picture = $Ui/MainUI/Picturefame/Picture
@onready var talker_name = $Ui/MainUI/Picturefame/Panel/Name


func _ready() -> void:
	choice_box.size.y = 0.0
	choice_box.size.x = 391.0
	instructions_label.modulate.a = 0.0
	objective_box.size.y = 0.0
	await get_tree().create_timer(2.0).timeout
	show_info()
	show_objective()
	await get_tree().create_timer(5.0).timeout
	hide_objective()
	hide_info()
	update_face_and_name("res://assets/faces/Leo.png", "Leo")


func show_info() -> void:
	var info_tween = get_tree().create_tween()
	info_tween.tween_property(choice_box, "size:y", 163.0, 0.55)
	info_tween.tween_property(choice_box, "size:x", 573.0, 0.50)
	info_tween.tween_property(instructions_label, "modulate:a", 1.0, 1.0)

func update_instructions(instructions) -> void:
	instructions_label.text = instructions

func hide_info() -> void:
	var hide_info_tween = get_tree().create_tween()
	hide_info_tween.tween_property(instructions_label, "modulate:a", 0.0, 1.0)
	hide_info_tween.tween_property(choice_box, "size:x", 391.0, 0.25)
	hide_info_tween.tween_property(choice_box, "size:y", 0.0, 0.25)

func show_objective() -> void:
	var show_obj_tween = get_tree().create_tween()
	show_obj_tween.tween_property(objective_box, "size:y", 32.0, 0.25)
	await get_tree().create_timer(0.5).timeout
	update_objective("Current Objective: Save Dane.")


func hide_objective() -> void:
	var fade_tween = get_tree().create_tween()
	fade_tween.tween_property(objective_label, "modulate:a", 0.0, 0.25)
	var size_tween = get_tree().create_tween()
	size_tween.tween_property(objective_box, "size:y", 0.0, 0.25)

func update_objective(objective_str) -> void:
	objective_label.bbcode = objective_str 

func update_face_and_name(face_location, name_input) -> void:
	picture.texture = load(face_location)
	talker_name.text = name_input
