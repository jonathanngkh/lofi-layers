extends TankGoblinState


# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	tank_goblin.hit_box.damage = tank_goblin.damage
	tank_goblin.sprite.animation_finished.connect(_on_animation_finished)
	tank_goblin.sprite.frame_changed.connect(_on_frame_changed)
	tank_goblin.sprite.offset = Vector2(15, 0)
	tank_goblin.velocity.x = 0
	tank_goblin.hit_box.previously_hit_hurtboxes = []
	
	tank_goblin.sprite.play("heavy_attack")


func _on_animation_finished() -> void:
	if tank_goblin.sprite.animation == "heavy_attack":
		tank_goblin.is_resting = true
		tank_goblin.rest_timer.start(tank_goblin.rest_duration)
		state_machine.transition_to("Idle")
		

# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	pass
	#if tank_goblin.sprite.frame >= 4:
		#tank_goblin.hit_box.process_mode = Node.PROCESS_MODE_INHERIT
		#for area in tank_goblin.hit_box.get_overlapping_areas():
			#if not overlapping_areas.has(area):
				#hit(area)


## Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	pass


# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	tank_goblin.sprite.animation_finished.disconnect(_on_animation_finished)
	tank_goblin.sprite.frame_changed.disconnect(_on_frame_changed)
	tank_goblin.sprite.offset = Vector2.ZERO
	tank_goblin.hit_box.process_mode = Node.PROCESS_MODE_DISABLED


func _on_frame_changed() -> void:
	if tank_goblin.sprite.frame == 5:
		tank_goblin.hit_box.process_mode = Node.PROCESS_MODE_INHERIT
		var tween = create_tween()
		var direction = tank_goblin.sprite.scale.x
		tween.tween_property(tank_goblin, "velocity:x", 0, 0.3).from(direction * tank_goblin.SPEED * 6)
	if tank_goblin.sprite.frame == 9:
		tank_goblin.hit_box.process_mode = Node.PROCESS_MODE_DISABLED
	if tank_goblin.sprite.frame == 11:
		tank_goblin.hit_box.previously_hit_hurtboxes = []
		var tween = create_tween()
		var direction = tank_goblin.sprite.scale.x
		tween.tween_property(tank_goblin, "velocity:x", 0, 0.3).from(direction * tank_goblin.SPEED * 6)
		tank_goblin.hit_box.process_mode = Node.PROCESS_MODE_INHERIT
	if tank_goblin.sprite.frame == 14:
		tank_goblin.hit_box.process_mode = Node.PROCESS_MODE_DISABLED
	if tank_goblin.sprite.frame == 21:
		var x_tween = create_tween()
		var direction = tank_goblin.sprite.scale.x
		x_tween.tween_property(tank_goblin, "velocity:x", 0, 0.4).from(direction * tank_goblin.SPEED * 20)
		var tween = create_tween()
		tween.tween_property(tank_goblin, "velocity:y", -800, 0.2)
		tween.tween_property(tank_goblin, "velocity:y", 0, 0.2)
		
	if tank_goblin.sprite.frame == 27:
		tank_goblin.hit_box.process_mode = Node.PROCESS_MODE_INHERIT
		tank_goblin.hit_box.previously_hit_hurtboxes = []
		tank_goblin.hit_box.damage *= 2
		
	if tank_goblin.sprite.frame == 30:
		tank_goblin.hit_box.process_mode = Node.PROCESS_MODE_DISABLED
