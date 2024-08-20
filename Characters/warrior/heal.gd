extends WarriorState
# 15 frames


#var freeze_launch_preload = preload("res://utility/freeze_launch_animated_sprite_2d.tscn")


# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	#print("equipped note: " + str(warrior.equipped_note))
	warrior.hurt_box.process_mode = Node.PROCESS_MODE_DISABLED
	warrior.sprite.animation_finished.connect(_on_animation_finished)
	warrior.sprite.frame_changed.connect(_on_frame_changed)
	warrior.sprite.play("heal", 1.1)
	warrior.sprite.offset = Vector2(86, -8)
	warrior.velocity.x = 0
	warrior.hit_box.previously_hit_hurtboxes = []
	warrior.aura.visible = false
	warrior.can_heal = false
	var notes_to_remove = []
	for i in range(4, -1, -1):
		if warrior.saved_notes.size() >= i+3:
			if warrior.saved_notes[i] == "Do" and warrior.saved_notes[i+1] == "Fa" and warrior.saved_notes[i+2] == "So":
				notes_to_remove.append(warrior.saved_notes[i+2])
				notes_to_remove.append(warrior.saved_notes[i+1])
				notes_to_remove.append(warrior.saved_notes[i+0])
				var tween1 = create_tween()
				tween1.tween_property(warrior.saved_notes_hbox.get_children()[i].get_children()[0], "self_modulate:v", 1, 0.4).from(100)
				var tween2 = create_tween()
				tween2.tween_property(warrior.saved_notes_hbox.get_children()[i+1].get_children()[0], "self_modulate:v", 1, 0.4).from(100)
				var tween3 = create_tween()
				tween3.tween_property(warrior.saved_notes_hbox.get_children()[i+2].get_children()[0], "self_modulate:v", 1, 0.4).from(100)
				#warrior.sampler.play_note("C", 3)
				#warrior.sampler.play_note("F", 3)
				#warrior.sampler.play_note("G", 3)
				break
	for note in notes_to_remove:
		warrior.saved_notes.reverse()
		warrior.saved_notes.erase(note)
		warrior.saved_notes.reverse()
	

func _on_animation_finished() -> void:
	if warrior.sprite.animation == "heal":
		state_machine.transition_to("Idle")


#func hit(area: Area2D) -> void:
	#print('hit ' + str(area) + ' in physics')
	#overlapping_areas.append(area)


# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	pass
	#if warrior.sprite.frame >= 16:
		#warrior.hit_box.process_mode = Node.PROCESS_MODE_INHERIT
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
	warrior.hit_box.process_mode = Node.PROCESS_MODE_DISABLED
	warrior.hurt_box.process_mode = Node.PROCESS_MODE_INHERIT


func _on_frame_changed() -> void:
	if warrior.sprite.frame == 6:
		$AudioStreamPlayer.play()
	if warrior.sprite.frame == 8:
		warrior.update_saved_notes()
	if warrior.sprite.frame == 10:
		warrior.hp += 5
		warrior.health_bar_control.heal(5)
		
