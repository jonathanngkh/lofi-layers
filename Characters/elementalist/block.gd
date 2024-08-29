# idle state
extends ElementalistState

var hover := false
var block_health := 2

# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	elementalist.sprite.offset.x = 0
	elementalist.velocity.x = 0
	elementalist.sprite.play("block_start", 1.8)
	elementalist.sprite.animation_finished.connect(_on_animation_finished)
	elementalist.hurt_box.mouse_entered.connect(_on_mouse_entered)
	elementalist.hurt_box.mouse_exited.connect(_on_mouse_exited)


## Corresponds to the `_process()` callback.
#func update(_delta: float) -> void:
	#pass


# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	pass
	#for area in elementalist.hurt_box.get_overlapping_areas():
		#if not area.owner.hit_victim.is_connected(block_hit):
			#area.owner.hit_victim.connect(block_hit)
			#print('connected to hit')
			
	#pass
	#if Input.is_action_pressed("block"):
		#elementalist.velocity.x = 0
	#if not elementalist.velocity.x == 0:
		#state_machine.transition_to("Run")
	#if not elementalist.velocity.y == 0:
		#state_machine.transition_to("Jump", {"stage": "apex"})


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
	var event_is_mouse_click: bool = (
		_event is InputEventMouseButton and
		_event.button_index == MOUSE_BUTTON_LEFT and
		_event.pressed
	)
	if event_is_mouse_click and hover:
		block_hit()
	
	if elementalist.sprite.animation == "block":
		if Input.get_axis("left", "right") > 0:
			elementalist.sprite.scale.x = 1
		elif Input.get_axis("left", "right") < 0:
			elementalist.sprite.scale.x = -1
		else:
			elementalist.velocity.x = move_toward(elementalist.velocity.x, 0, elementalist.SPEED)
	# jump
	if Input.is_action_just_pressed("jump") and elementalist.is_on_floor():
		state_machine.transition_to("Jump")
	# release block
	if not Input.is_action_pressed("block") and not elementalist.sprite.animation == "block_break" and not elementalist.sprite.animation == "block_hit":
		elementalist.sprite.play("block_end", 1.8)
	if Input.is_action_pressed("light_attack") and elementalist.can_attack_while_blocking:
		state_machine.transition_to("LightAttack1")


func block_hit() -> void:
	# no invincibility yet: block health will go down even during block hit animation
	if block_health > 0:
		if elementalist.sprite.animation == "block_hit":
			elementalist.sprite.stop()
		elementalist.sprite.play("block_hit")
		block_health -= 1
	else:
		elementalist.sprite.play("block_break", 1.2)


# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	elementalist.sprite.animation_finished.disconnect(_on_animation_finished)
	elementalist.hurt_box.mouse_entered.disconnect(_on_mouse_entered)
	elementalist.hurt_box.mouse_exited.disconnect(_on_mouse_exited)
	block_health = 2
