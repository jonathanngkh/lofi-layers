extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	OS.open_midi_inputs()
	print(OS.get_connected_midi_inputs())


func _unhandled_input(event: InputEvent) -> void:
	
	if event is InputEventMIDI:
		var note_on: bool = (event.message == 9)
		var note_off: bool = (event.message == 8)
		
		if note_on:
			if event.pitch == 60:
				print('C4 on')
		if note_off:
			if event.pitch == 60:
				print('C4 off')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
