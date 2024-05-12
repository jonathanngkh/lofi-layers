class_name Note

extends Control

# set note as str
#@export var pitch_english: String = "C#4"
#@export var pitch: int = MusicTheory.PITCHES[pitch_english]

# set note as int
@export var pitch: int = 60
@export var pitch_english: String = MusicTheory.PITCHES[pitch] # exported so that can inspect pitch

@export var length: int = MusicTheory.NOTE_LENGTHS["SEMIBREVE"]
@export var length_english: String = "SEMIBREVE"

@export var is_accented: bool = false

#func _ready() -> void:
	#print(pitch)
