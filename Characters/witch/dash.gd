extends WitchState

var dash_speed = 2000

# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	$DashDurationTimer.wait_time = 1.0
	$DashDurationTimer.start()
	$DashDurationTimer.timeout.connect(_on_timeout)
	witch.sprite.offset.x = 0
	var tween = create_tween()
	tween.tween_property(self, "dash_speed", 0, 0.8).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	witch.sprite.play("to_dash")
	witch.sprite.animation_finished.connect(_on_animation_finished)


# Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	pass

# Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	pass

func _on_timeout() -> void:
	witch.sprite.play("dash_brake")

# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	witch.velocity.x = dash_speed

func _on_animation_finished() -> void:
	if witch.sprite.animation == "to_dash":
		witch.sprite.play("dash")
	elif witch.sprite.animation == "dash_brake":
		state_machine.transition_to("Idle")


# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	witch.sprite.animation_finished.disconnect(_on_animation_finished)
	witch.sprite.offset.x = 40
	$DashDurationTimer.timeout.disconnect(_on_timeout)
