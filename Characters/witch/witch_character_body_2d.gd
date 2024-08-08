class_name Witch
extends CharacterBody2D

const SPEED = 500.0
const JUMP_VELOCITY = -1900.0
const BRAKING_SPEED = 400.0
@export var debug_mode = false

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hurt_box: Area2D = $HurtBox
@onready var state_machine: StateMachine = $StateMachine

func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	if debug_mode:
		$Label.visible = true
		$Label2.visible = true
		$Label.text = "state: " + $StateMachine.state.name
		$Label2.text = "animation: " + sprite.animation
	else:
		$Label.visible = false
		$Label2.visible = false
		
	# Add the gravity.
	if not is_on_floor() and not $StateMachine.state.name == "Dash":
		velocity += get_gravity() * delta
		
	move_and_slide()


func receive_hit() -> void:
	print('witch was hit')
	if state_machine.state == $StateMachine/Block:
		$StateMachine/Block.block_hit()
		print('hit was blocked')

func _unhandled_input(_event: InputEvent) -> void:
	pass
