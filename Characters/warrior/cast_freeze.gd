extends WarriorState

var freeze_launch_preload = preload("res://utility/freeze_launch_animated_sprite_2d.tscn")


# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	#print("equipped note: " + str(warrior.equipped_note))
	warrior.sprite.animation_finished.connect(_on_animation_finished)
	warrior.sprite.frame_changed.connect(_on_frame_changed)
	warrior.sprite.play("cast", 1.1)
	warrior.sprite.offset = Vector2(79, -16)
	warrior.velocity.x = 0
	warrior.hit_box.previously_hit_hurtboxes = []
	warrior.aura.visible = false
	#warrior.saved_notes = []
	warrior.update_saved_notes()
	#warrior._on_hit()
	$AudioStreamPlayer.play()
	
func _on_animation_finished() -> void:
	if warrior.sprite.animation == "cast":
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
		var freeze_launch_spawn = freeze_launch_preload.instantiate()
		warrior.add_child(freeze_launch_spawn)
		freeze_launch_spawn.position.y -= 30
