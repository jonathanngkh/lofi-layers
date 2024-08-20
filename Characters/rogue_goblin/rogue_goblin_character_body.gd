class_name RogueGoblin
extends CharacterBody2D

@export var damage := 2
@export var random_notes_mode := false
var note_rotate_dict := {
	"Do": 0,
	"Re": 1,
	"Mi": 2,
	"Fa": 3,
	"So": 4,
	"La": 5,
	"Ti": 6,
}
@onready var solfege_container: Control = $SolfegeWheel/SolfegeContainer
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hit_box: Area2D = $AnimatedSprite2D/HitBox
@onready var hurt_box: Area2D = $HurtBox
@onready var state_machine: StateMachine = $StateMachine
@onready var move_detection: Area2D = $AnimatedSprite2D/MoveRange
@onready var attack_detection: Area2D = $AnimatedSprite2D/AttackRange
@onready var attack_timer: Timer = $AttackTimer
@export var is_played_controlled:= false
@export var note_health := ["Do"]
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var note_preloads := {
	"Do": preload("res://utility/do_ui.tscn"),
	"Re": preload("res://utility/re_ui.tscn"),
	"Mi": preload("res://utility/mi_ui.tscn"),
	"Fa": preload("res://utility/fa_ui.tscn"),
	"So": preload("res://utility/so_ui.tscn"),
	"La": preload("res://utility/la_ui.tscn"),
	"Ti": preload("res://utility/ti_ui.tscn"),
}

var player_chase := false
var can_attack := true

func _ready() -> void:
	for i in range(note_rotate_dict[note_health[0]]):
		for solfege in solfege_container.get_children():
			solfege.solfege_forward()
	hit_box.process_mode = Node.PROCESS_MODE_DISABLED
	#for note in note_health:
		#var note_ui_spawn = note_preloads[note].instantiate()
		#for container in $HBoxContainer.get_children():
			#if container.get_child_count() == 0:
				#container.add_child(note_ui_spawn)
				#break
	attack_timer.timeout.connect(_on_attack_timer_timeout)
	
func _on_attack_timer_timeout():
	can_attack = true

func _physics_process(delta: float) -> void:
	for solfege_note in solfege_container.get_children():
		if solfege_note.position == Vector2(-11, -45):
			note_health[0] = solfege_note.name.left(2)
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
