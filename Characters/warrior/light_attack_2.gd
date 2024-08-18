extends WarriorState

var queue_jump := false

@onready var sword_sounds := [
	preload("res://Characters/warrior/sounds/sword/sfx_sword_lightslash_01.wav"),
	preload("res://Characters/warrior/sounds/sword/sfx_sword_lightslash_02.wav"),
	preload("res://Characters/warrior/sounds/sword/sfx_sword_lightslash_03.wav"),
	preload("res://Characters/warrior/sounds/sword/sfx_sword_lightslash_04.wav"),
	preload("res://Characters/warrior/sounds/sword/sfx_sword_lightslash_05.wav"),
	preload("res://Characters/warrior/sounds/sword/sfx_sword_lightslash_06.wav"),
]

@onready var solfege_balls := [
	preload("res://utility/do.tscn"),
	preload("res://utility/re.tscn"),
	preload("res://utility/mi.tscn"),
	preload("res://utility/fa.tscn"),
	preload("res://utility/so.tscn"),
	preload("res://utility/la.tscn"),
	preload("res://utility/ti.tscn"),
]

# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	warrior.velocity.y = 0
	#print("equipped note: " + str(warrior.equipped_note))
	warrior.sprite.animation_finished.connect(_on_animation_finished)
	warrior.sprite.frame_changed.connect(_on_frame_changed)
	warrior.sprite.play("light_attack_2", 1.8)
	warrior.sprite.offset = Vector2(24, -8)
	warrior.velocity.x = 0
	warrior.hit_box.previously_hit_hurtboxes = []
	warrior.hit_box.launch = true
	#$AudioStreamPlayer.stream = sword_sounds.pick_random()
	#$AudioStreamPlayer.play()
	#warrior.sampler.play_note(warrior.minor_scale[warrior.minor_scale_index][0], warrior.minor_scale[warrior.minor_scale_index][1])
	#warrior.label_3.text = "played_note: " + warrior.minor_scale[warrior.minor_scale_index][0] + str(warrior.minor_scale[warrior.minor_scale_index][1])
	##warrior.sampler.play_note(warrior.chromatic_scale[warrior.chromatic_scale_index][0], warrior.chromatic_scale[warrior.chromatic_scale_index][1])
	#if warrior.minor_scale_index < 7:
		#warrior.minor_scale_index += 1
	#else:
		#warrior.minor_scale_index = 0
	#warrior.label_4.text = "next_note: " + warrior.minor_scale[warrior.minor_scale_index][0] + str(warrior.minor_scale[warrior.minor_scale_index][1])


func _on_animation_finished() -> void:
	if warrior.sprite.animation == "light_attack_2":
		warrior.sprite.play("light_attack_end", 1.8)
	elif warrior.sprite.animation == "light_attack_end":
		state_machine.transition_to("Idle")


#func hit(area: Area2D) -> void:
	#print('hit ' + str(area) + ' in physics')
	#overlapping_areas.append(area)


# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	if warrior.sprite.frame >= 4:
		warrior.hit_box.process_mode = Node.PROCESS_MODE_INHERIT
		#warrior.hit_box.tone = "Re"
		#for area in warrior.hit_box.get_overlapping_areas():
			#if not overlapping_areas.has(area):
				#hit(area)


## Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	# dash
	if Input.is_action_pressed("jump"):
		queue_jump = true
		#state_machine.transition_to("Jump")
	if not warrior.sprite.animation == "light_attack_2":
		if Input.is_action_just_pressed("dash"):
			state_machine.transition_to("Dash")
		# block
		if Input.is_action_pressed("block"):
			state_machine.transition_to("Block")


# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	warrior.sprite.animation_finished.disconnect(_on_animation_finished)
	warrior.sprite.frame_changed.disconnect(_on_frame_changed)
	warrior.sprite.offset = Vector2.ZERO
	warrior.hit_box.process_mode = Node.PROCESS_MODE_DISABLED
	warrior.hit_box.launch = false
	queue_jump = false
	


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
		$AudioStreamPlayer.stream = sword_sounds.pick_random()
		$AudioStreamPlayer.play()
	if warrior.sprite.frame == 5:
		pass
		#if warrior.equipped_note == "Do":
			#warrior.sampler.play_note("C", 5)
			#var do_spawn = solfege_balls[0].instantiate()
			#do_spawn.position = Vector2.ZERO
			#do_spawn.get_node("Label").position = Vector2(7, 5)
			#warrior.note_container.get_children()[0].add_child(do_spawn)
			#if not warrior.saved_notes.has("Do"):
				#warrior.saved_notes.append("Do")
		#elif warrior.equipped_note == "Re":
			#warrior.sampler.play_note("D", 5)
			#var re_spawn = solfege_balls[1].instantiate()
			#re_spawn.position = Vector2.ZERO
			#re_spawn.get_node("Label").position = Vector2(7, 5)
			#re_spawn.position = Vector2.ZERO
			#warrior.note_container.get_children()[1].add_child(re_spawn)
			#if not warrior.saved_notes.has("Re"):
				#warrior.saved_notes.append("Re")
		#elif warrior.equipped_note == "Mi":
			#warrior.sampler.play_note("E", 5)
			#var mi_spawn = solfege_balls[2].instantiate()
			#mi_spawn.position = Vector2.ZERO
			#mi_spawn.get_node("Label").position = Vector2(7, 5)
			#warrior.note_container.get_children()[2].add_child(mi_spawn)
			#if not warrior.saved_notes.has("Mi"):
				#warrior.saved_notes.append("Mi")
		#elif warrior.equipped_note == "Fa":
			#warrior.sampler.play_note("F", 5)
			#var fa_spawn = solfege_balls[3].instantiate()
			#fa_spawn.position = Vector2.ZERO
			#fa_spawn.get_node("Label").position = Vector2(7, 5)
			#warrior.note_container.get_children()[3].add_child(fa_spawn)
			#if not warrior.saved_notes.has("Fa"):
				#warrior.saved_notes.append("Fa")
		#elif warrior.equipped_note == "So":
			#warrior.sampler.play_note("G", 5)
			#var so_spawn = solfege_balls[4].instantiate()
			#so_spawn.get_node("Label").position = Vector2(7, 5)
			#warrior.note_container.get_children()[4].add_child(so_spawn)
			#if not warrior.saved_notes.has("So"):
				#warrior.saved_notes.append("So")
		#elif warrior.equipped_note == "La":
			#warrior.sampler.play_note("A", 5)
			#var la_spawn = solfege_balls[5].instantiate()
			#la_spawn.get_node("Label").position = Vector2(7, 5)
			#warrior.note_container.get_children()[5].add_child(la_spawn)
			#if not warrior.saved_notes.has("La"):
				#warrior.saved_notes.append("La")
		#elif warrior.equipped_note == "Ti":
			#warrior.sampler.play_note("B", 5)
			#var ti_spawn = solfege_balls[6].instantiate()
			#ti_spawn.get_node("Label").position = Vector2(7, 5)
			#warrior.note_container.get_children()[6].add_child(ti_spawn)
			#if not warrior.saved_notes.has("Ti"):
				#warrior.saved_notes.append("Ti")
		#
		#if warrior.saved_notes.size() >= 4:
			#state_machine.transition_to("HolySword")

	if warrior.sprite.frame >= 6:
		if queue_jump:
			state_machine.transition_to("Jump")
