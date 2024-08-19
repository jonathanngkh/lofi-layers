class_name Warrior
extends CharacterBody2D

var can_holy_sword = false
@export var hp := 20
var saved_notes := []
var can_dash = true
#@onready var solfege_notes := ["Do", "Re", "Mi", "Fa", "So", "La", "Ti"]
#@onready var solfege_notes_index := 0
#@onready var equipped_note : String = solfege_notes[solfege_notes_index]
@onready var camera: Camera2D = $Camera2D

@export var debug_mode := false
@export var can_attack_while_blocking := true
@export var beat_em_up_mode := true
@onready var saved_notes_hbox: HBoxContainer = $CanvasLayer/SavedNotesHBoxContainer
@onready var dash_cooldown_timer: Timer = $StateMachine/Dash/DashCooldownTimer

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hurt_box: Area2D = $HurtBox
@onready var hit_box: Area2D = $AnimatedSprite2D/HitBox
@onready var hit_box_2: HitBox = $AnimatedSprite2D/HitBox2
@onready var hit_box_3: HitBox = $AnimatedSprite2D/HitBox3
@onready var health_bar_control: Control = $CanvasLayer/HealthBarControl

@onready var state_machine: StateMachine = $StateMachine
@onready var sampler: SamplerInstrument = $SamplerInstrument
@onready var aura: AnimatedSprite2D = $AnimatedSprite2D/AuraAnimatedSprite2D

@onready var label_3: Label = $Label3
@onready var label_4: Label = $Label4
@onready var note_container: Control = $NoteContainer


@onready var solfege_container: Control = $SolfegeWheel/SolfegeContainer

@onready var note_preloads := {
	"Do": preload("res://utility/do_ui.tscn"),
	"Re": preload("res://utility/re_ui.tscn"),
	"Mi": preload("res://utility/mi_ui.tscn"),
	"Fa": preload("res://utility/fa_ui.tscn"),
	"So": preload("res://utility/so_ui.tscn"),
	"La": preload("res://utility/la_ui.tscn"),
	"Ti": preload("res://utility/ti_ui.tscn"),
}

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
	hit_box.hit_signal.connect(_on_hit)
	hit_box_2.process_mode = Node.PROCESS_MODE_DISABLED
	hit_box_2.hit_signal.connect(_on_hit)
	hit_box_3.process_mode = Node.PROCESS_MODE_DISABLED
	hit_box_3.hit_signal.connect(_on_hit)
	dash_cooldown_timer.timeout.connect(func() -> void: can_dash = true)
	label_4.text = "next_note: " + minor_scale[minor_scale_index][0] + str(minor_scale[minor_scale_index][1])


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("special_attack"):
		if can_holy_sword:
			state_machine.transition_to("HolySword")

func _on_hit(message) -> void:
	camera.apply_shake()


func update_saved_notes() -> void:
	print("saved notes: " + str(saved_notes))
	for container in saved_notes_hbox.get_children():
		for note_ui in container.get_children():
			note_ui.free()
	
	for saved_note in saved_notes:
		var note_ui_spawn = note_preloads[saved_note].instantiate()
		for container in saved_notes_hbox.get_children():
			if container.get_child_count() == 0:
				container.add_child(note_ui_spawn)
				container.modulate.a = 1.0
				break
				
	if saved_notes.has("Do") and saved_notes.has("Mi") and saved_notes.has("So"):
		can_holy_sword = true
		$AnimatedSprite2D/AuraAnimatedSprite2D.visible = true
		$AnimatedSprite2D/AuraAnimatedSprite2D.play()
	


func _physics_process(delta: float) -> void:
	#if Input.is_action_just_pressed("solfege_backward"):
		#if solfege_notes_index > -(solfege_notes.size() - 1):
			#solfege_notes_index -= 1
			#equipped_note = solfege_notes[solfege_notes_index]
		#else:
			#solfege_notes_index = 0
			#equipped_note = solfege_notes[solfege_notes_index]
			#
		#for ball in solfege_container.get_children():
			#ball.solfege_backward()
			#
	#if Input.is_action_just_pressed("solfege_forward"):
		#if solfege_notes_index < solfege_notes.size() - 1:
			#solfege_notes_index += 1
			#equipped_note = solfege_notes[solfege_notes_index]
		#else:
			#solfege_notes_index = 0
			#equipped_note = solfege_notes[solfege_notes_index]
			#
		#for ball in solfege_container.get_children():
			#ball.solfege_forward()

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


func receive_hit(message) -> void:
	if message is int:
		if not state_machine.state == $StateMachine/Block:
			hp -= message
			$CanvasLayer/HealthBarControl.damage(message)
	if hp <= 0:
		state_machine.transition_to("Death")
	elif state_machine.state == $StateMachine/Block:
		$StateMachine/Block.block_hit()
	else:
		state_machine.transition_to("Hurt")
