extends WarriorState

#@onready var footstep_sounds := [
	#preload("res://Characters/warrior/sounds/footsteps/sfx_footsteps_grass_01.wav"),
	#preload("res://Characters/warrior/sounds/footsteps/sfx_footsteps_grass_02.wav"),
	#preload("res://Characters/warrior/sounds/footsteps/sfx_footsteps_grass_03.wav"),
	#preload("res://Characters/warrior/sounds/footsteps/sfx_footsteps_grass_04.wav"),
	#preload("res://Characters/warrior/sounds/footsteps/sfx_footsteps_grass_05.wav")
#]

@onready var footstep_sounds := [
	preload("res://assets/sfx/grass_walk_3.mp3"),
	preload("res://assets/sfx/grass_walk_2.mp3"),
	preload("res://assets/sfx/grass_walk_1.mp3"),
]

# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	warrior.sprite.animation_finished.connect(_on_animation_finished)
	warrior.sprite.frame_changed.connect(_on_frame_changed)
	warrior.sprite.play("run_start", 1.6)

	if Input.get_axis("left", "right") == 0:
		state_machine.transition_to("Idle")


func _on_animation_finished() -> void:
	if warrior.sprite.animation == "run_start":
		warrior.sprite.play("run")
	#if warrior.sprite.animation == "run_break":
		#state_machine.transition_to("Idle")


# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	pass
	#if not warrior.sprite.animation == "run_break":
		## down
		#if Input.get_axis("up", "down") > 0:
			#warrior.sprite.play("run")
			#warrior.position.y += 10
		## up
		#elif Input.get_axis("up", "down") < 0:
			#warrior.sprite.play("run")
			#warrior.position.y += -10
		#else:
			#warrior.sprite.play("run_break")
			#var tween = create_tween()
			#tween.tween_property(warrior, "velocity:y", 0, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)


## Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	if not warrior.sprite.animation == "run_break":
		if Input.get_axis("left", "right") > 0:
			warrior.sprite.scale.x = 1
			warrior.velocity.x = 1 * warrior.SPEED
			warrior.sprite.play("run")
		elif Input.get_axis("left", "right") < 0:
			warrior.sprite.scale.x = -1
			warrior.velocity.x = -1 * warrior.SPEED
			warrior.sprite.play("run")
		elif Input.get_axis("left", "right") == 0 and Input.get_axis("up", "down") == 0:
			if warrior.velocity.x > 0:
				warrior.sprite.scale.x = 1
			elif warrior.velocity.x < 0:
				warrior.sprite.scale.x = -1
			state_machine.transition_to("Idle")
			#warrior.sprite.play("run_break", 1.5)
			#var tween = create_tween()
			#tween.tween_property(warrior, "velocity:x", 0, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	# jump
	if Input.is_action_just_pressed("jump") and warrior.is_on_floor():
		state_machine.transition_to("Jump")
	# dash
	if Input.is_action_just_pressed("dash") and warrior.can_dash:
		state_machine.transition_to("Dash")
	# block
	if Input.is_action_pressed("block"):
		state_machine.transition_to("Block")
	# attack
	if Input.is_action_just_pressed("light_attack"):
		state_machine.transition_to("LightAttack1")
	#if Input.is_action_pressed("heavy_attack"):
		#state_machine.transition_to("HeavyAttack")
	#if Input.is_action_just_pressed("shield_attack"):
		#state_machine.transition_to("ShieldHeavyAttack")
		
	#if Input.is_action_just_pressed("freeze"):
		#state_machine.transition_to("CastFreeze")
	#if Input.is_action_just_pressed("holy_wave"):
		#state_machine.transition_to("HolyWave")
	#if Input.is_action_just_pressed("heal"):
		#state_machine.transition_to("Heal")

func _on_frame_changed() -> void:
	if warrior.sprite.frame == 2:
		$AudioStreamPlayer2D.stream = footstep_sounds.pick_random()
		$AudioStreamPlayer2D.play()
	if warrior.sprite.frame == 6:
		$AudioStreamPlayer2D.stream = footstep_sounds.pick_random()
		$AudioStreamPlayer2D.play()
	

# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	warrior.sprite.animation_finished.disconnect(_on_animation_finished)
	warrior.sprite.frame_changed.disconnect(_on_frame_changed)
