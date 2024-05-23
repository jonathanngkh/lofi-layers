class_name Note

# idea is to be able to drag and drop as resource in inspector later to quickly make segments

extends Control

# set note as str
#@export var pitch_english: String = "C#4"
#@export var pitch: int = MusicTheory.PITCHES[pitch_english]

# set note as int
@export var pitch: int = 60
@export var pitch_english: String = MusicTheoryDB.PITCHES[pitch] # exported so that can inspect

@export var length: int = MusicTheoryDB.NOTE_LENGTHS["SEMIBREVE"]
@export var length_english: String = "SEMIBREVE"

@export var is_accented: bool = false

#func _ready() -> void:
	#print(pitch)
