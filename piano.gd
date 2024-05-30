extends Control

#region onready variables
@onready var c_5_texture_button: TextureButton = %C5TextureButton
@onready var d_5_texture_button: TextureButton = %D5TextureButton
@onready var e_5_texture_button: TextureButton = %E5TextureButton
@onready var f_5_texture_button: TextureButton = %F5TextureButton
@onready var g_5_texture_button: TextureButton = %G5TextureButton
@onready var a_5_texture_button: TextureButton = %A5TextureButton
@onready var b_5_texture_button: TextureButton = %B5TextureButton
@onready var c_sharp_5_texture_button: TextureButton = %CSharp5TextureButton
@onready var d_sharp_5_texture_button: TextureButton = %DSharp5TextureButton
@onready var f_sharp_5_texture_button: TextureButton = %FSharp5TextureButton
@onready var g_sharp_5_texture_button: TextureButton = %GSharp5TextureButton
@onready var a_sharp_5_texture_button: TextureButton = %ASharp5TextureButton
#endregion


@onready var pitch_node_dictionary: Dictionary = {
	72: c_5_texture_button,
	73: c_sharp_5_texture_button,
	74: d_5_texture_button,
	75: d_sharp_5_texture_button,
	76: e_5_texture_button,
	77: f_5_texture_button,
	78: f_sharp_5_texture_button,
	79: g_5_texture_button,
	80: g_sharp_5_texture_button,
	81: a_5_texture_button,
	82: a_sharp_5_texture_button,
	83: b_5_texture_button,
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(pitch_node_dictionary[72])
	MidiListener.connect("note_on", key_down)
	MidiListener.connect("note_off", key_up)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func key_down(note_played :  int) -> void:
	print(note_played, " played")
	pitch_node_dictionary[note_played].button_pressed = true


func key_up(note_released : int) -> void:
	print(note_released, " released")
	pitch_node_dictionary[note_released].button_pressed = false
