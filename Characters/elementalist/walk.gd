extends ElementalistState

# Called when the node enters the scene tree for the first time.
func enter(_msg := {}) -> void:
	elementalist.sprite.animation_finished.connect(_on_animation_finished)
	elementalist.sprite.play("walk")


# Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	pass


# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
		# left or right
	var x_vector := Input.get_axis("left", "right")
	if Input.get_axis("left", "right") > 0:
		elementalist.sprite.scale.x = 1
		#x_vector = 1
	elif Input.get_axis("left", "right") < 0:
		elementalist.sprite.scale.x = -1
		#x_vector = -1
	#elif Input.get_axis("left", "right") == 0:
		#x_vector = 0
	
	var y_vector := Input.get_axis("up", "down")
	#if Input.get_axis("up", "down") > 0:
		#y_vector = 1
	#elif Input.get_axis("up", "down") < 0:
		#y_vector = -1
	#elif Input.get_axis("up", "down") == 0:
		#y_vector = 0
	
	var direction_vector := Vector2(x_vector, y_vector)
	elementalist.velocity = direction_vector.normalized() * elementalist.SPEED
	elementalist.move_and_slide()


func _on_animation_finished() -> void:
	pass


# Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	controls()


func controls() -> void:
	if Input.get_axis("left", "right") == 0 and Input.get_axis("down", "up") == 0:
		state_machine.transition_to("Idle")
		
	# dash
	if Input.is_action_just_pressed("dash"):
		state_machine.transition_to("Dash")
	# jump
	if Input.is_action_just_pressed("jump") and elementalist.is_on_floor():
		state_machine.transition_to("Jump")
	# block
	if Input.is_action_pressed("block"):
		state_machine.transition_to("Block")
	if Input.is_action_pressed("light_attack"):
		state_machine.transition_to("LightAttack1")

# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	elementalist.sprite.animation_finished.disconnect(_on_animation_finished)
