class_name FemaleGoblin
extends CharacterBody2D

@export var damage := 2
@export var max_fireball_count := 3

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hit_box: Area2D = $AnimatedSprite2D/HitBox
@onready var hurt_box: Area2D = $HurtBox
@onready var state_machine: StateMachine = $StateMachine
@onready var charge_timer: Timer = $StateMachine/Charge/ChargeTimer
@onready var move_detection: Area2D = $AnimatedSprite2D/MoveRange
@onready var attack_detection: Area2D = $AnimatedSprite2D/AttackRange
@onready var cast_detection: Area2D = $AnimatedSprite2D/CastRange
@onready var attack_timer: Timer = $AttackTimer
@onready var separation_distance: int = abs(move_detection.get_child(0).get_shape().get_rect().size.x/2) * self.scale.x
@export var is_played_controlled:= false
@export var note_health := ["Do"]

@onready var note_preloads := {
	"Do": preload("res://utility/do_ui.tscn"),
	"Re": preload("res://utility/re_ui.tscn"),
	"Mi": preload("res://utility/mi_ui.tscn"),
	"Fa": preload("res://utility/fa_ui.tscn"),
	"So": preload("res://utility/so_ui.tscn"),
	"La": preload("res://utility/la_ui.tscn"),
	"Ti": preload("res://utility/ti_ui.tscn"),
}

const attack_delay = 0.8
const SPEED = 400.0
const JUMP_VELOCITY = -400.0

var run_away := false
var can_attack := true

func _ready() -> void:
	hit_box.process_mode = Node.PROCESS_MODE_DISABLED
	for note in note_health:
		var note_ui_spawn = note_preloads[note].instantiate()
		for container in $HBoxContainer.get_children():
			if container.get_child_count() == 0:
				container.add_child(note_ui_spawn)
				break
	attack_timer.timeout.connect(_on_attack_timer_timeout)

func _on_attack_timer_timeout():
	can_attack = true

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

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

func receive_hit(message) -> void:
	if message == "freeze":
		print('frozen')
		state_machine.transition_to("Freeze")
	elif message == "holy_sword":
		state_machine.transition_to("Death")
	else:
		state_machine.transition_to("Hurt")
