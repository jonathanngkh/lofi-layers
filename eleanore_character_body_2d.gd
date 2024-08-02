extends CharacterBody2D


const SPEED = 500.0
const JUMP_VELOCITY = -1800.0
const BRAKING_SPEED = 1000.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	PhysicsServer2D.area_set_param(get_viewport().find_world_2d().space, PhysicsServer2D.AREA_PARAM_GRAVITY, 980*6)
	sprite.play("idle")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		var direction := Input.get_axis("left", "right")
		if direction:
			if direction == -1:
				sprite.scale.x = -1
			else:
				sprite.scale.x = 1
			sprite.play("walk")
			velocity.x = direction * SPEED
		else:
			sprite.play("idle")
			velocity.x = move_toward(velocity.x, 0, SPEED)

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		sprite.play("jump")
		velocity.y = JUMP_VELOCITY
		
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#if not sprite.animation == "jump":

	move_and_slide()
