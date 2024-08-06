extends WarriorState


# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	warrior.sprite.animation_finished.connect(_on_animation_finished)
	warrior.hit_box.area_entered.connect(_hit)
	warrior.sprite.play("light_attack_1", 1.8)
	warrior.sprite.offset = Vector2(24, -8)
	warrior.velocity.x = 0


func _on_animation_finished() -> void:
	if warrior.sprite.animation == "light_attack_1":
		warrior.sprite.play("light_attack_end", 1.8)
	elif warrior.sprite.animation == "light_attack_end":
		state_machine.transition_to("Idle")


func _hit() -> void:
	pass

# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	pass


## Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	# dash
	if Input.is_action_just_pressed("dash"):
		state_machine.transition_to("Dash")
	# block
	if Input.is_action_pressed("block"):
		state_machine.transition_to("Block")


# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	warrior.sprite.animation_finished.disconnect(_on_animation_finished)
	warrior.hit_box.area_entered.disconnect(_hit)
	warrior.sprite.offset = Vector2.ZERO
