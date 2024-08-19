extends FemaleGoblinState

var fireball_packed_scene = preload("res://Characters/female_goblin/fireball.tscn")
var hero_global_position := Vector2.ZERO
var fireball_count := 1
var rng = RandomNumberGenerator.new()
@onready var cast_sounds = [
	preload("res://Characters/female_goblin/fireball/sfx/sfx_enemy_magegoblin_fireballthrow.wav")
]
# Called by the state machine upon changing the active state. The `msg` parameter is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	female_goblin.sprite.animation_finished.connect(_on_animation_finished)
	female_goblin.sprite.frame_changed.connect(_on_frame_changed)
	female_goblin.sprite.offset = Vector2(-15, 0)
	female_goblin.velocity.x = 0
	female_goblin.hit_box.previously_hit_hurtboxes = []
	female_goblin.hit_box.damage = female_goblin.damage
	female_goblin.sprite.play("cast_fireball")
	$AudioStreamPlayer2D.stream = cast_sounds[0]
	$AudioStreamPlayer2D.play()
	fireball_count = rng.randf_range(1, female_goblin.max_fireball_count)


func _on_animation_finished() -> void:
	if female_goblin.sprite.animation == "cast_fireball":
		female_goblin.can_attack = false
		female_goblin.attack_timer.start(female_goblin.attack_delay)
		state_machine.transition_to("Idle")


#func hit(area: Area2D) -> void:
	#print('hit ' + str(area) + ' in physics')
	#overlapping_areas.append(area)


# Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	pass
	#if female_goblin.sprite.frame >= 4:
		#female_goblin.hit_box.process_mode = Node.PROCESS_MODE_INHERIT
		#for area in female_goblin.hit_box.get_overlapping_areas():
			#if not overlapping_areas.has(area):
				#hit(area)


## Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	pass


# Called by the state machine before changing the active state. Use this function to clean up the state.
func exit() -> void:
	female_goblin.sprite.animation_finished.disconnect(_on_animation_finished)
	female_goblin.sprite.frame_changed.disconnect(_on_frame_changed)
	female_goblin.sprite.offset = Vector2.ZERO
	female_goblin.hit_box.process_mode = Node.PROCESS_MODE_DISABLED


func _on_frame_changed() -> void:
	if female_goblin.sprite.frame == 4:
		for i in range(fireball_count):
			var fireball_spawn = fireball_packed_scene.instantiate()
			
			fireball_spawn.global_position = female_goblin.global_position
			# puts the fireball as child of world object
			owner.get_parent().add_child(fireball_spawn)
			fireball_spawn.sprite.scale.x *= female_goblin.sprite.scale.x
			fireball_spawn.velocity.y = i * -100
			fireball_spawn.velocity.x = female_goblin.sprite.scale.x * fireball_spawn.SPEED
			fireball_spawn.hit_box.previously_hit_hurtboxes.append(female_goblin.hurt_box)
			fireball_spawn.hit_box.damage = female_goblin.damage
			fireball_spawn.hit_box.process_mode = Node.PROCESS_MODE_INHERIT
		
		
