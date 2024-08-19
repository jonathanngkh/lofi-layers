extends Control

@onready var slots = [$Slot1,$Slot2,$Slot3,$Slot4,$Slot5,$Slot6,$Slot7]

var notes = ["Do","Re","Mi","Fa","So","La","Ti"]
var colors = ["ff2645","ff7212","ffcc00","33ff40","1ae6ff","5980ff","b34dff"]

func _ready() -> void:
	pass

var count = 0
#func _input(event:InputEvent) -> void:
	#if event.is_action_pressed("ui_accept"):
		#add_note_into_left_empty_slot(notes[count])
		#if count < 6: 
			#count+=1
	#if event.is_action_pressed("ui_down"):
		#remove_note_from_rightmost_slot()
		#if count > 0:
			#count -=1


func add_note_into_left_empty_slot(note):
	var noteIndex = notes.find(note)
	var foundEmptySlot = false
	for slot in slots:
		if foundEmptySlot == false:
			if slot.get_child_count() == 0:
				#print("empty slot found at: %s" % slots.find(slot))
				var note_effect_spawn = preload("res://utility/NoteSlotsControl/note_effect.tscn").instantiate()
				note_effect_spawn.set_meta("NoteType",note)
				note_effect_spawn.self_modulate = Color(colors[noteIndex])
				slot.add_child(note_effect_spawn)
				note_effect_spawn.set_speed_scale(2.0)
				note_effect_spawn.play(note)
				foundEmptySlot = true

func remove_note_from_rightmost_slot():
	var foundFilledSlot = false
	slots.reverse()
	for slot in slots:
		if foundFilledSlot == false:
			if slot.get_child_count() > 0:
				var children = slot.get_children()
				for child in children:
					var animation = child.animation
					child.set_speed_scale(5.0)
					child.animation_finished.connect(_animation_finished)
					child.play_backwards(animation)
				foundFilledSlot = true
	slots.reverse()			

func _animation_finished():
	for slot in slots:
		if slot.get_child_count() > 0:
			var children = slot.get_children()
			for child in children:
				if child.frame == 0:
					slot.remove_child(child)
