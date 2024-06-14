extends Control

@onready var a_string_note_container: BoxContainer = $TabBoxRichTextLabel/UkuleleTab/AString/AStringNoteContainer
@onready var e_string_note_container: BoxContainer = $TabBoxRichTextLabel/UkuleleTab/EString/EStringNoteContainer
@onready var c_string_note_container: BoxContainer = $TabBoxRichTextLabel/UkuleleTab/CString/CStringNoteContainer
@onready var g_string_note_container: BoxContainer = $TabBoxRichTextLabel/UkuleleTab/GString/GStringNoteContainer
@onready var note_containers := [g_string_note_container, c_string_note_container, e_string_note_container, a_string_note_container]
@onready var blank_style_box_flat = preload("res://assets/themes/blank_style_box_flat.tres")
@onready var character: TextureRect = $Character
@onready var dialogue_rich_text_label: RichTextLabel = $DialogueRichTextLabel
@onready var next_button: Button = $NextButton
@onready var talking_synth: AudioStreamPlayer = $TalkingSynth
@onready var talking_timer: Timer = $TalkingTimer
@onready var note_explosion: CPUParticles2D = $NoteExplosionCPUParticles2D


var dialogue_items : Array[Dictionary] = [
	{"text": "[b]Harmonious[/b] Hellos, Amy!",
	"expression": "happy"},
	
	{"text": "I'm Pink. I'll be your scales practice coach.",
	"expression": "regular"},
	
	{"text": "Let's get great at ukulele together!",
	"expression": "determined"},
	
	{"text": "Watch what happens when you play the note that's [wave amp=30 freq=15]bouncing![/wave]",
	"expression": "determined"},
]

var wave_effect := "[wave amp=30 freq=15]"
var rainbow_effect := "[rainbow]"
var shake_effect := "[shake]"
var pulse_effect := "[pulse]"
var fade_effect := "[fade]"
var tornado_effect := "[tornado]"

@export var pink_pitch_scale := 0.9
var seconds_per_character := 0.4/18.0
@export var current_index: int = 0
@onready var current_item: Dictionary = dialogue_items[current_index]
@onready var text_appearing_duration: float = current_item["text"].length() * seconds_per_character
var talking_playback_position := 0.0
@onready var current_note_label = $TabBoxRichTextLabel/UkuleleTab/CString/CStringNoteContainer/NoteRichTextLabel
#@onready var current_note = int(current_note_label.text[-1]) # convert from uku tab to midi pitch
@onready var current_note = 60
var is_checking_notes = false
var snapped_note # converted detected pitch note for checking
@onready var note_explosion_effect = preload("res://assets/vfx/note_explosion_cpu_particles_2d.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PitchDetector.connect("detected_pitch", get_closest_note_detected)
	reset_tabs()
	next_button.connect("pressed", _on_next_button_button_pressed)
	talking_timer.connect("timeout", _on_talking_timer_timeout)
	talk()
	show_text()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	#if is_checking_notes:
		#check_note(current_note)

func get_closest_note_detected(note_detected) -> void:
	# convert string pitch detected 44.4 to int 44
	if is_checking_notes:
		snapped_note = snapped(float(note_detected), 1)
		print(snapped_note)
		check_note(current_note)


func check_note(note_to_check) -> void:
	if snapped_note == 60 and current_note == 60: # C
		current_note_label.text = rainbow_effect + current_note_label.text[-1]
		note_explosion.emitting = true
		current_note_label = $TabBoxRichTextLabel/UkuleleTab/CString/CStringNoteContainer/NoteRichTextLabel3
		current_note_label.text = wave_effect + current_note_label.text[-1]
		current_note = 62
	elif snapped_note == 62  and current_note == 62: # D
		note_explosion.emitting = true
		note_explosion.position = Vector2(676, 571)
		current_note_label.text = rainbow_effect + current_note_label.text[-1]
		current_note_label = $TabBoxRichTextLabel/UkuleleTab/EString/EStringNoteContainer/NoteRichTextLabel5
		current_note_label.text = wave_effect + current_note_label.text[-1]
		current_note = 64
	elif snapped_note == 64 and current_note == 64: # E
		note_explosion.emitting = true
		note_explosion.position = Vector2(895, 470)
		current_note_label.text = rainbow_effect + current_note_label.text[-1]
		current_note_label = $TabBoxRichTextLabel/UkuleleTab/EString/EStringNoteContainer/NoteRichTextLabel7
		current_note_label.text = wave_effect + current_note_label.text[-1]
		current_note = 66
	elif snapped_note == 66 and current_note == 66: # F
		note_explosion.emitting = true
		note_explosion.position = Vector2(1118, 470)
		current_note_label.text = rainbow_effect + current_note_label.text[-1]
		current_note_label = $TabBoxRichTextLabel/UkuleleTab/EString/EStringNoteContainer/NoteRichTextLabel9
		current_note_label.text = wave_effect + current_note_label.text[-1]
		current_note = 67
	elif snapped_note == 67 and current_note == 67:
		note_explosion.emitting = true
		note_explosion.position = Vector2(1340, 470)
		current_note_label.text = rainbow_effect + current_note_label.text[-1]
		current_note_label = $TabBoxRichTextLabel/UkuleleTab/AString/AStringNoteContainer/NoteRichTextLabel11
		current_note_label.text = wave_effect + current_note_label.text[-1]
		current_note = 69
	elif snapped_note == 69 and current_note == 69:
		note_explosion.emitting = true
		note_explosion.position = Vector2(1556, 367)
		current_note_label.text = rainbow_effect + current_note_label.text[-1]
		current_note_label = $TabBoxRichTextLabel/UkuleleTab/AString/AStringNoteContainer/NoteRichTextLabel13
		current_note_label.text = wave_effect + current_note_label.text[-1]
		current_note = 71
	elif snapped_note == 71 and current_note == 71:
		note_explosion.emitting = true
		note_explosion.position = Vector2(1779, 367)
		current_note_label.text = rainbow_effect + current_note_label.text[-1]
		current_note_label = $TabBoxRichTextLabel/UkuleleTab/AString/AStringNoteContainer/NoteRichTextLabel15
		current_note_label.text = wave_effect + current_note_label.text[-1]
		current_note = 72
	elif snapped_note == 72 and current_note == 72:
		note_explosion.emitting = true
		note_explosion.position = Vector2(1999, 367)
		current_note_label.text = rainbow_effect + current_note_label.text[-1]
		

func set_current_note_label(new_node: Control) -> void:
	current_note_label = new_node

func reset_tabs() -> void:
	for note_container in note_containers:
		for note_label in note_container.get_children():
			#note_label.text = "1"
			note_label.add_theme_stylebox_override("normal", blank_style_box_flat) # remove tab_note border
			#note_label.text = wave_string + note_label.text


func _on_next_button_button_pressed() -> void:
	advance_dialogue()
	slide_in()
	next_button.button_pressed = false


func slide_in() -> void:
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(character, "position:x", 194, 0.5).from(400) # slide left
	
	tween = create_tween() # tween in parallel
	tween.tween_property(character, "modulate:a", 1.0, 0.2).from(0.0) # fade in


func advance_dialogue() -> void:
	if current_index + 1 < dialogue_items.size():
		current_index += 1
	show_text()


func _on_talking_timer_timeout() -> void:
	talking_playback_position = talking_synth.get_playback_position()
	talking_synth.stop()
	if current_index == 3:
		is_checking_notes = true
	if not current_index == dialogue_items.size() - 1:
		$NextButton/ButtonUpSound.play()
		next_button.disabled = false
		next_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND


func talk() -> void:
	text_appearing_duration = float(current_item["text"].length()) * seconds_per_character
	talking_timer.wait_time = text_appearing_duration
	talking_synth.pitch_scale = pink_pitch_scale
	talking_synth.play(talking_playback_position)
	talking_timer.start()
	next_button.disabled = true
	next_button.mouse_default_cursor_shape = Control.CURSOR_FORBIDDEN


func show_text() -> void:
	current_item = dialogue_items[current_index]
	dialogue_rich_text_label.text = current_item["text"]
	character.expression = current_item["expression"]
	talk()
	var tween = create_tween()
	tween.tween_property(dialogue_rich_text_label, "visible_ratio", 1, text_appearing_duration).from(0.0)
