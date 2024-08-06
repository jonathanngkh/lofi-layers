extends WarriorState

var dash_speed = 1000
var starting_direction
var starting_height
var dash_cancelled := false
var can_end_dash := false

# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	starting_direction = warrior.sprite.scale.x
	starting_height = warrior.position.y
	warrior.sprite.play("dash_start", 2.5)
	warrior.sprite.animation_finished.connect(_on_animation_finished)


# Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	if _event.is_action_released("dash"):
		dash_cancelled = true


# Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	if Input.is_action_pressed("jump"):
		starting_height -= 10


# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	warrior.velocity.x = starting_direction * dash_speed
	warrior.position.y = starting_height
	if dash_cancelled and can_end_dash:
		end_dash()


func end_dash() -> void:
	if not warrior.sprite.animation == "dash_break":
		if warrior.is_on_floor():
			warrior.sprite.play("dash_break", 1.3)
			var tween = create_tween()
			tween.tween_property(self, "dash_speed", 0, 0.4).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
		else:
			state_machine.transition_to("Jump", {"stage": "apex"}) # double jump can be used repeatedly for infinite height


func _on_animation_finished() -> void:
	if warrior.sprite.animation == "dash_start":
		can_end_dash = true
		warrior.sprite.play("dash")
	elif warrior.sprite.animation == "dash_break":
		state_machine.transition_to("Idle")


func _on_timeout() -> void:
	warrior.sprite.play("dash_break")
	var tween = create_tween()
	tween.tween_property(self, "dash_speed", 0, 0.4).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)


# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	warrior.sprite.animation_finished.disconnect(_on_animation_finished)
	dash_speed = 1000
	warrior.velocity.y = 0
	dash_cancelled = false
	can_end_dash = false
