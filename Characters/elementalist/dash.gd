extends ElementalistState

var starting_direction
var starting_height
var dash_cancelled := false
var can_end_dash := false
var dash_duration := 0.2
var ghost_spawn_frequency := 0.05
var dash_ghost_preload := preload("res://utility/dash_ghost.tscn")


# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	$DashDurationTimer.wait_time = dash_duration
	$DashDurationTimer.timeout.connect(_on_duration_timer_timeout)
	$DashDurationTimer.start()
	$GhostSpawnTimer.wait_time = ghost_spawn_frequency
	$GhostSpawnTimer.timeout.connect(func() -> void: spawn_ghost())
	$GhostSpawnTimer.start()
	spawn_ghost()
	elementalist.sprite.play("dash", 1.2)
	elementalist.sprite.animation_finished.connect(_on_animation_finished)
	



func spawn_ghost() -> void:
	var ghost_spawn = dash_ghost_preload.instantiate()
	get_owner().get_parent().add_child(ghost_spawn)
	ghost_spawn.scale = elementalist.scale
	ghost_spawn.scale.x *= elementalist.sprite.scale.x
	ghost_spawn.global_position = elementalist.global_position
	ghost_spawn.position.y += -120
	ghost_spawn.sprite_frames = elementalist.sprite.sprite_frames
	ghost_spawn.animation = elementalist.sprite.animation
	ghost_spawn.frame = elementalist.sprite.frame


# Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	if _event.is_action_released("dash"):
		dash_cancelled = true


# Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	pass


# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	if Input.get_axis("left", "right") > 0:
		elementalist.sprite.scale.x = 1
	elif Input.get_axis("left", "right") < 0:
		elementalist.sprite.scale.x = -1
	var x_vector := Input.get_axis("left", "right")
	var y_vector := Input.get_axis("up", "down")
	var direction_vector := Vector2(x_vector, y_vector)
	elementalist.velocity = direction_vector.normalized() * elementalist.SPEED * 2
	elementalist.move_and_slide()


func _on_animation_finished() -> void:
	pass


func _on_duration_timer_timeout() -> void:
	if not Input.get_axis("left", "right") == 0 or not Input.get_axis("up", "down") == 0:
		state_machine.transition_to("Walk")
	else:
		state_machine.transition_to("Idle")


# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	elementalist.sprite.animation_finished.disconnect(_on_animation_finished)
	$DashDurationTimer.timeout.disconnect(_on_duration_timer_timeout)
	$GhostSpawnTimer.stop()
	#$GhostSpawnTimer.timeout.disconnect(func() -> void: spawn_ghost())
