extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MidiListener.connect("note_on", key_down)
	MidiListener.connect("note_off", key_up)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func key_down(note_played :  int) -> void:
	print(note_played)
	if note_played == 72:
		$HBoxContainer/C_TextureButton.button_pressed = true


func key_up(note_released : int) -> void:
	print(note_released)
	if note_released == 72:
		$HBoxContainer/C_TextureButton.button_pressed = false
