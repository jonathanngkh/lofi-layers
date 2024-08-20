# idle state
extends WarriorState

var hover := false
var block_health := 2

# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	warrior.velocity.x = 0
	warrior.sprite.animation_finished.connect(_on_animation_finished)
	warrior.hurt_box.mouse_entered.connect(_on_mouse_entered)
	warrior.hurt_box.mouse_exited.connect(_on_mouse_exited)
	if _msg:
		if _msg["from"] == "shield_attack":
			warrior.sprite.play("block")
	else:
		$AudioStreamPlayer.play()
		warrior.sprite.play("block_start")
	
	if not Input.is_action_pressed("block") and not warrior.sprite.animation == "block_break" and not warrior.sprite.animation == "block_hit":
		#warrior.sprite.play("block_end")
		state_machine.transition_to("Idle")
#
#
## Corresponds to the `_process()` callback.
#func update(_delta: float) -> void:
	#pass
#
#
# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	warrior.velocity.x = 0
	#if Input.is_action_pressed("block"):
		#warrior.velocity.x = 0
	#if not warrior.velocity.x == 0:
		#state_machine.transition_to("Run")
	#if not warrior.velocity.y == 0:
		#state_machine.transition_to("Jump", {"stage": "apex"})


func _on_animation_finished() -> void:
	if warrior.sprite.animation == "block_start":
		warrior.sprite.play("block")
	if warrior.sprite.animation == "block_end":
		state_machine.transition_to("Idle")
	if warrior.sprite.animation == "block_hit":
		warrior.sprite.play("block")
	if warrior.sprite.animation == "block_break":
		state_machine.transition_to("Idle")


func _on_mouse_entered() -> void:
	hover = true
	pass


func _on_mouse_exited() -> void:
	hover = false
	pass


# Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	var event_is_mouse_click: bool = (
		_event is InputEventMouseButton and
		_event.button_index == MOUSE_BUTTON_LEFT and
		_event.pressed
	)
	if event_is_mouse_click and hover:
		block_hit()
	
	if not (warrior.sprite.animation == "block_hit" or warrior.sprite.animation == "block_break"):
		
		if Input.get_axis("left", "right") > 0:
			warrior.sprite.scale.x = 1
		elif Input.get_axis("left", "right") < 0:
			warrior.sprite.scale.x = -1
		else:
			warrior.velocity.x = move_toward(warrior.velocity.x, 0, warrior.SPEED)
		
		if Input.is_action_just_pressed("dash") and warrior.can_dash:
			state_machine.transition_to("Dash")
	# jump
	if Input.is_action_just_pressed("jump") and warrior.is_on_floor():
		state_machine.transition_to("Jump")
	# release block
	if not Input.is_action_pressed("block") and not warrior.sprite.animation == "block_break" and not warrior.sprite.animation == "block_hit":
		#warrior.sprite.play("block_end")
		state_machine.transition_to("Idle")
	if Input.is_action_pressed("light_attack") and warrior.can_attack_while_blocking:
		state_machine.transition_to("LightAttack1")
	if Input.is_action_pressed("heavy_attack"):
		state_machine.transition_to("ShieldHeavyAttack")


func block_hit() -> void:
	# no invincibility yet: block health will go down even during block hit animation
	$AudioStreamPlayer_BlockHit.play()
	if block_health > 0:
		if warrior.sprite.animation == "block_hit":
			warrior.sprite.stop()
		warrior.sprite.play("block_hit")
		block_health -= 1
	else:
		warrior.sprite.play("block_break")


# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	warrior.sprite.animation_finished.disconnect(_on_animation_finished)
	warrior.hurt_box.mouse_entered.disconnect(_on_mouse_entered)
	warrior.hurt_box.mouse_exited.disconnect(_on_mouse_exited)
	block_health = 2
