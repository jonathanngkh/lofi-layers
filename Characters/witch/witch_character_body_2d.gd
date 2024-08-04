class_name Witch
extends CharacterBody2D

const SPEED = 1000.0
const JUMP_VELOCITY = -1900.0
const BRAKING_SPEED = 400.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	PhysicsServer2D.area_set_param(get_viewport().find_world_2d().space, PhysicsServer2D.AREA_PARAM_GRAVITY, 980*6)
	#sprite.play("idle")

func _physics_process(delta: float) -> void:
	$Label.text = "state: " + $StateMachine.state.name
	$Label2.text = "animation: " + sprite.animation
	# Add the gravity.
	if not is_on_floor() and not $StateMachine.state.name == "Dash":
		velocity += get_gravity() * delta
		
	move_and_slide()
	

func _unhandled_input(_event: InputEvent) -> void:
	pass
	#if Input.is_action_pressed("left"):
		#sprite.scale.x = -1
		#velocity.x = -1 * SPEED
	#elif Input.is_action_pressed("right"):
		#sprite.scale.x = 1
		#velocity.x = 1 * SPEED
	#elif Input.is_action_just_released("left") or Input.is_action_just_released("right"):
		#velocity.x = move_toward(velocity.x, 0, SPEED)
	#if Input.is_action_just_pressed("jump") and is_on_floor():
		#state_machine.transition_to("Jump")
