class_name Warrior
extends CharacterBody2D


var saved_notes := []
@onready var solfege_notes := ["Do", "Re", "Mi", "Fa", "So", "La", "Ti"]
@onready var solfege_notes_index := 0
@onready var equipped_note : String = solfege_notes[solfege_notes_index]

@export var debug_mode := false
@export var can_attack_while_blocking := true
@export var beat_em_up_mode := true

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hurt_box: Area2D = $HurtBox
@onready var hit_box: Area2D = $AnimatedSprite2D/HitBox
@onready var state_machine: StateMachine = $StateMachine
@onready var sampler: SamplerInstrument = $SamplerInstrument

@onready var label_3: Label = $Label3
@onready var label_4: Label = $Label4
@onready var note_container: Control = $NoteContainer


@onready var solfege_container: Control = $SolfegeWheel/SolfegeContainer



var minor_scale := [
	["A", 4],
	["B", 4],
	["C", 5],
	["D", 5],
	["E", 5],
	["F", 5],
	["G#", 5],
	["A", 5],
]

var minor_scale_index = 0

const SPEED = 500.0
const JUMP_VELOCITY = -2100.0

func _ready() -> void:
	hit_box.process_mode = Node.PROCESS_MODE_DISABLED
	label_4.text = "next_note: " + minor_scale[minor_scale_index][0] + str(minor_scale[minor_scale_index][1])

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("solfege_backward"):
		if solfege_notes_index > -(solfege_notes.size() - 1):
			solfege_notes_index -= 1
			equipped_note = solfege_notes[solfege_notes_index]
		else:
			solfege_notes_index = 0
			equipped_note = solfege_notes[solfege_notes_index]
			
		for ball in solfege_container.get_children():
			ball.solfege_backward()
			
	if Input.is_action_just_pressed("solfege_forward"):
		if solfege_notes_index < solfege_notes.size() - 1:
			solfege_notes_index += 1
			equipped_note = solfege_notes[solfege_notes_index]
		else:
			solfege_notes_index = 0
			equipped_note = solfege_notes[solfege_notes_index]
			
		for ball in solfege_container.get_children():
			ball.solfege_forward()

	if debug_mode:
		$Label.visible = true
		$Label2.visible = true
		$Label.text = "state: " + $StateMachine.state.name
		$Label2.text = "animation: " + sprite.animation
	else:
		$Label.visible = false
		$Label2.visible = false
		
	 # Gravity.
	#if not beat_em_up_mode:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	#if state_machine.state == $StateMachine/Jump:
		#velocity += get_gravity() * delta

	move_and_slide()


func receive_hit() -> void:
	if state_machine.state == $StateMachine/Block:
		$StateMachine/Block.block_hit()
	else:
		state_machine.transition_to("Hurt")
