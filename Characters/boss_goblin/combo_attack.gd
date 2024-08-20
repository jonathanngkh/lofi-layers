extends BossGoblinState


# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	boss_goblin.sprite.animation_finished.connect(_on_animation_finished)
	boss_goblin.sprite.frame_changed.connect(_on_frame_changed)
	boss_goblin.sprite.play("combo_attack")
	boss_goblin.sprite.offset = Vector2(0, 15)
	boss_goblin.velocity.x = 0
	boss_goblin.hit_box_1.previously_hit_hurtboxes = []


func _on_animation_finished() -> void:
	if boss_goblin.sprite.animation == "combo_attack":
		state_machine.transition_to("Idle")



# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	pass


## Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	pass


# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	boss_goblin.sprite.animation_finished.disconnect(_on_animation_finished)
	boss_goblin.sprite.frame_changed.disconnect(_on_frame_changed)
	boss_goblin.sprite.offset = Vector2.ZERO
	boss_goblin.hit_box_1.process_mode = Node.PROCESS_MODE_DISABLED


func _on_frame_changed() -> void:
	if boss_goblin.sprite.frame == 6:
		boss_goblin.hit_box_1.process_mode = Node.PROCESS_MODE_INHERIT
		
	if boss_goblin.sprite.frame == 9:
		boss_goblin.hit_box_1.process_mode = Node.PROCESS_MODE_DISABLED
		
	if boss_goblin.sprite.frame == 12:
		boss_goblin.hit_box_1.previously_hit_hurtboxes = []
		boss_goblin.hit_box_1.process_mode = Node.PROCESS_MODE_INHERIT
		
	if boss_goblin.sprite.frame == 15:
		boss_goblin.hit_box_1.process_mode = Node.PROCESS_MODE_DISABLED
		
	if boss_goblin.sprite.frame == 22:
		boss_goblin.hit_box_2.previously_hit_hurtboxes = []
		boss_goblin.hit_box_2.process_mode = Node.PROCESS_MODE_INHERIT
		
	if boss_goblin.sprite.frame == 27:
		boss_goblin.hit_box_2.process_mode = Node.PROCESS_MODE_DISABLED
	
