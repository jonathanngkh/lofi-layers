extends Control

@onready var a_string_note_container: BoxContainer = $TabBoxRichTextLabel/UkuleleTab/AString/AStringNoteContainer
@onready var e_string_note_container: BoxContainer = $TabBoxRichTextLabel/UkuleleTab/EString/EStringNoteContainer
@onready var c_string_note_container: BoxContainer = $TabBoxRichTextLabel/UkuleleTab/CString/CStringNoteContainer
@onready var g_string_note_container: BoxContainer = $TabBoxRichTextLabel/UkuleleTab/GString/GStringNoteContainer
@onready var note_containers := [g_string_note_container, c_string_note_container, e_string_note_container, a_string_note_container]
@onready var blank_style_box_flat = preload("res://assets/themes/blank_style_box_flat.tres")
@onready var character: TextureRect = $Character
@onready var dialogue_rich_text_label: RichTextLabel = $DialogueRichTextLabel

var wave_effect := "[wave amp=30 freq=15]"
var rainbow_effect := "[rainbow]"
var shake_effect := "[shake]"
var pulse_effect := "[pulse]"
var fade_effect := "[fade]"
var tornado_effect := "[tornado]"

@onready var dialogue_items : Array[Dictionary] = [
	{"text": "[b]Harmonious[/b] Hellos!",
	"expression": "happy"},
	
	{"text": "I'm Pink. I'll be your scales practice coach.",
	"expression": "regular"},
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset_tabs()
	dialogue_rich_text_label.text = dialogue_items[0]["text"]
	character.expression = dialogue_items[0]["expression"]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func reset_tabs() -> void:
	# remove tab_note border
	for note_container in note_containers:
		for note_label in note_container.get_children():
			#note_label.text = "1"
			note_label.add_theme_stylebox_override("normal", blank_style_box_flat)
			#note_label.text = wave_string + note_label.text
