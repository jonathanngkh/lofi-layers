extends WarriorState


var overlapping_areas = [Area2D]
# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	warrior.sprite.animation_finished.connect(_on_animation_finished)
	warrior.sprite.frame_changed.connect(_on_frame_changed)
	warrior.sprite.play("light_attack_1", 1.8)
	warrior.sprite.offset = Vector2(24, -8)
	warrior.velocity.x = 0
	overlapping_areas = []


func _on_animation_finished() -> void:
	if warrior.sprite.animation == "light_attack_1":
		warrior.sprite.play("light_attack_end", 1.8)
	elif warrior.sprite.animation == "light_attack_end":
		state_machine.transition_to("Idle")


func hit(area: Area2D) -> void:
	print('hit ' + str(area) + ' in physics')
	overlapping_areas.append(area)
	warrior.hit_victim.emit(warrior)
	

# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	if warrior.sprite.frame >= 3:
		for area in warrior.hit_box.get_overlapping_areas():
			if not overlapping_areas.has(area):
				hit(area)


## Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	# dash
	if not warrior.sprite.animation == "light_attack_1":
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
