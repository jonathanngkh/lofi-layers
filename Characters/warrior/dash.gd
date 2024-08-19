extends WarriorState

@export var dash_speed = 1800
var starting_direction
var starting_height

# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	#dash_speed = 1800
	starting_direction = warrior.sprite.scale.x
	starting_height = warrior.position.y
	warrior.sprite.play("dash_start", 2.5)
	warrior.sprite.animation_finished.connect(_on_animation_finished)
	warrior.sprite.frame_changed.connect(_on_frame_changed)
	warrior.hurt_box.process_mode = Node.PROCESS_MODE_DISABLED
	$AudioStreamPlayer.play()


# Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("block"):
		state_machine.transition_to("ShieldHeavyAttack")
	if Input.is_action_just_pressed("light_attack"):
		state_machine.transition_to("HeavyAttack")
	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Jump")

# Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	pass


# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	warrior.position.y = starting_height
	if not warrior.sprite.animation == "dash_break":
		warrior.velocity.x = starting_direction * dash_speed


func end_dash() -> void:
	if not warrior.sprite.animation == "dash_break":
		#warrior.velocity.y = 0
		#if warrior.is_on_floor():
		warrior.sprite.play("dash_break", 2.0)
		var tween = create_tween()
		tween.tween_property(warrior, "velocity:x", 0, 0.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
		#else:
			#state_machine.transition_to("Jump", {"stage": "apex"}) # double jump can be used repeatedly for infinite height


func _on_animation_finished() -> void:
	if warrior.sprite.animation == "dash_start":
		warrior.sprite.play("dash", 3.5)
	elif warrior.sprite.animation == "dash":
		end_dash()
	elif warrior.sprite.animation == "dash_break":
		state_machine.transition_to("Idle")


#func _on_timeout() -> void:
	#warrior.sprite.play("dash_break")
	#var tween = create_tween()
	#tween.tween_property(self, "dash_speed", 0, 0.4).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)


# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	if warrior.sprite.animation_finished.is_connected(_on_animation_finished):
		warrior.sprite.animation_finished.disconnect(_on_animation_finished)
	if warrior.sprite.frame_changed.is_connected(_on_frame_changed):
		warrior.sprite.frame_changed.disconnect(_on_frame_changed)
	warrior.velocity.y = 0
	warrior.hurt_box.process_mode = Node.PROCESS_MODE_INHERIT
	warrior.can_dash = false
	warrior.dash_cooldown_timer.start(0.8)


func _on_frame_changed() -> void:
	pass
	#if warrior.sprite.frame == 3:
		#warrior.hurt_box.process_mode = Node.PROCESS_MODE_DISABLED
