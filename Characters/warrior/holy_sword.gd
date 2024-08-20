extends WarriorState



# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	#print("equipped note: " + str(warrior.equipped_note))
	warrior.sprite.animation_finished.connect(_on_animation_finished)
	warrior.sprite.frame_changed.connect(_on_frame_changed)
	warrior.sprite.play("holy_sword", 1.4)
	warrior.sprite.offset = Vector2(49, -36)
	warrior.velocity.x = 0
	warrior.hit_box_2.previously_hit_hurtboxes = []
	warrior.hit_box_2.holy_sword = true
	$AudioStreamPlayer.play()
	warrior.can_holy_sword = false
	warrior.aura.visible = false
	warrior.hurt_box.process_mode = Node.PROCESS_MODE_DISABLED


func _on_animation_finished() -> void:
	if warrior.sprite.animation == "holy_sword":
		state_machine.transition_to("Idle")


#func hit(area: Area2D) -> void:
	#print('hit ' + str(area) + ' in physics')
	#overlapping_areas.append(area)


# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	if warrior.sprite.frame == 10:
		var notes_to_remove = []
		var i = 0
		if warrior.saved_notes.size() >= 7:
			if warrior.saved_notes[i] == "Do" and warrior.saved_notes[i+1] == "Re" and warrior.saved_notes[i+2] == "Mi" and warrior.saved_notes[i+3] == "Fa" and warrior.saved_notes[i+4] == "So" and warrior.saved_notes[i+5] == "La" and warrior.saved_notes[i+6] == "Ti":
				notes_to_remove.append(warrior.saved_notes[i+6])
				notes_to_remove.append(warrior.saved_notes[i+5])
				notes_to_remove.append(warrior.saved_notes[i+4])
				notes_to_remove.append(warrior.saved_notes[i+3])
				notes_to_remove.append(warrior.saved_notes[i+2])
				notes_to_remove.append(warrior.saved_notes[i+1])
				notes_to_remove.append(warrior.saved_notes[i+0])
			var tween1 = create_tween()
			tween1.tween_property(warrior.saved_notes_hbox.get_children()[i+0].get_children()[0], "self_modulate:v", 1, 0.4).from(100)
			var tween2 = create_tween()
			tween2.tween_property(warrior.saved_notes_hbox.get_children()[i+1].get_children()[0], "self_modulate:v", 1, 0.4).from(100)
			var tween3 = create_tween()
			tween3.tween_property(warrior.saved_notes_hbox.get_children()[i+2].get_children()[0], "self_modulate:v", 1, 0.4).from(100)
			var tween4 = create_tween()
			tween4.tween_property(warrior.saved_notes_hbox.get_children()[i+3].get_children()[0], "self_modulate:v", 1, 0.4).from(100)
			var tween5 = create_tween()
			tween5.tween_property(warrior.saved_notes_hbox.get_children()[i+4].get_children()[0], "self_modulate:v", 1, 0.4).from(100)
			var tween6 = create_tween()
			tween6.tween_property(warrior.saved_notes_hbox.get_children()[i+5].get_children()[0], "self_modulate:v", 1, 0.4).from(100)
			var tween7 = create_tween()
			tween7.tween_property(warrior.saved_notes_hbox.get_children()[i+6].get_children()[0], "self_modulate:v", 1, 0.4).from(100)
		
		for note in notes_to_remove:
			warrior.saved_notes.reverse()
			warrior.saved_notes.erase(note)
			warrior.saved_notes.reverse()
			
	if warrior.sprite.frame >= 16:
		warrior.hit_box_2.process_mode = Node.PROCESS_MODE_INHERIT
		warrior.update_saved_notes()
		#warrior.hit_box.tone = "Re"
		#for area in warrior.hit_box.get_overlapping_areas():
			#if not overlapping_areas.has(area):
				#hit(area)


## Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	pass
	# dash
	#if not warrior.sprite.animation == "light_attack_1":
		#if Input.is_action_just_pressed("dash"):
			#state_machine.transition_to("Dash")
		## block
		#if Input.is_action_pressed("block"):
			#state_machine.transition_to("Block")


# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	warrior.sprite.animation_finished.disconnect(_on_animation_finished)
	warrior.sprite.frame_changed.disconnect(_on_frame_changed)
	warrior.sprite.offset = Vector2.ZERO
	#warrior.hit_box.process_mode = Node.PROCESS_MODE_DISABLED
	warrior.hit_box_2.process_mode = Node.PROCESS_MODE_DISABLED
	warrior.hurt_box.process_mode = Node.PROCESS_MODE_INHERIT
	warrior.hit_box_2.holy_sword = false

func _on_frame_changed() -> void:
	if warrior.sprite.frame == 0:
		pass
	if warrior.sprite.frame == 1:
		pass
	if warrior.sprite.frame == 2:
		pass
	if warrior.sprite.frame == 3:
		pass
	if warrior.sprite.frame == 4:
		pass
	if warrior.sprite.frame == 5:
		pass
	if warrior.sprite.frame == 6:
		pass
	if warrior.sprite.frame == 7:
		pass
