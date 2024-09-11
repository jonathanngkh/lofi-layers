class_name BossGoblin
extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hit_box_1: Area2D = $AnimatedSprite2D/HitBox1
@onready var hit_box_2: Area2D = $AnimatedSprite2D/HitBox2
@onready var hurt_box: Area2D = $HurtBox
@onready var state_machine: StateMachine = $StateMachine


const SPEED = 500.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var direction := Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func receive_hit() -> void:
	state_machine.transition_to("Hurt")