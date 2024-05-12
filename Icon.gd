extends Sprite2D

@onready var midi_player: MidiPlayer = $"../MidiPlayer"


func _ready() -> void:
	midi_player.connect("midi_event", _on_midi_player_midi_event)

func _on_midi_player_midi_event(channel, event) -> void:
	#global_position.y += 50
	pass
