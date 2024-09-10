# idle state
extends ElementalistState

var hover := false
var block_health := 2

# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	elementalist.sprite.play("block_start", 1.8)
	elementalist.sprite.animation_finished.connect(_on_animation_finished)
	elementalist.hurt_box.mouse_entered.connect(_on_mouse_entered)
	elementalist.hurt_box.mouse_exited.connect(_on_mouse_exited)


# Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	pass


# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	pass


func _on_animation_finished() -> void:
	if elementalist.sprite.animation == "block_start":
		elementalist.sprite.play("block", 1.2)
	if elementalist.sprite.animation == "block_hit":
		elementalist.sprite.play("block", 1.2)
	if elementalist.sprite.animation == "block_break":
		state_machine.transition_to("Idle")
	if elementalist.sprite.animation == "block_end":
		state_machine.transition_to("Idle")


func _on_mouse_entered() -> void:
	hover = true
	pass


func _on_mouse_exited() -> void:
	hover = false
	pass


# Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	# jump
	if Input.is_action_just_pressed("jump") and elementalist.is_on_floor():
		state_machine.transition_to("Jump")
	# release block
	if not Input.is_action_pressed("block") and not elementalist.sprite.animation == "block_break" and not elementalist.sprite.animation == "block_hit":
		elementalist.sprite.play("block_end", 1.8)
	if Input.is_action_pressed("light_attack") and elementalist.can_attack_while_blocking:
		state_machine.transition_to("LightAttack1")



# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	elementalist.sprite.animation_finished.disconnect(_on_animation_finished)
	elementalist.hurt_box.mouse_entered.disconnect(_on_mouse_entered)
	elementalist.hurt_box.mouse_exited.disconnect(_on_mouse_exited)
	block_health = 2
