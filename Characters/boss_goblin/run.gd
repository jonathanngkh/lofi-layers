extends BossGoblinState


# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	boss_goblin.sprite.animation_finished.connect(_on_animation_finished)
	boss_goblin.sprite.offset.y = 15
	boss_goblin.sprite.play("run")



func _on_animation_finished() -> void:
	pass


# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	# down
	if Input.get_axis("up", "down") > 0:
		boss_goblin.sprite.play("run")
		boss_goblin.position.y += 10
	# up
	elif Input.get_axis("up", "down") < 0:
		boss_goblin.sprite.play("run")
		boss_goblin.position.y += -10



## Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	pass


# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	boss_goblin.sprite.animation_finished.disconnect(_on_animation_finished)
