class_name Warrior
extends CharacterBody2D

var can_holy_sword = false
var can_heal = false
var can_holy_wave = false
var can_freeze = false

@export var hp := 20
var saved_notes := ["Do", "Fa", "So", "Do", "Fa", "So"]
var can_dash = true
var can_air_dash = true
@onready var solfege_notes := ["Do", "Re", "Mi", "Fa", "So", "La", "Ti"]
@onready var solfege_notes_index := 0
@onready var equipped_note : String = solfege_notes[solfege_notes_index]
@onready var camera: Camera2D = $Camera2D

@export var is_cheat_mode := false
@export var debug_mode := false
@export var can_attack_while_blocking := true
@export var beat_em_up_mode := true
@onready var saved_notes_hbox: HBoxContainer = $CanvasLayer/SavedNotesHBoxContainer
@onready var dash_cooldown_timer: Timer = $StateMachine/Dash/DashCooldownTimer
@onready var air_dash_cooldown_timer: Timer = $StateMachine/AirDash/DashCooldownTimer

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

@onready var tween1 = create_tween()
@onready var tween2 = create_tween()
@onready var tween3 = create_tween()
@onready var tween4 = create_tween()
@onready var tween5 = create_tween()
@onready var tween6 = create_tween()
@onready var tween7 = create_tween()


func _ready() -> void:
	hit_box.process_mode = Node.PROCESS_MODE_DISABLED
	hit_box.hit_signal.connect(_on_hit)
	hit_box_2.process_mode = Node.PROCESS_MODE_DISABLED
	hit_box_2.hit_signal.connect(_on_hit)
	hit_box_3.process_mode = Node.PROCESS_MODE_DISABLED
	hit_box_3.hit_signal.connect(_on_hit)
	dash_cooldown_timer.timeout.connect(func() -> void: can_dash = true)
	air_dash_cooldown_timer.timeout.connect(func() -> void: can_air_dash = true)
	label_4.text = "next_note: " + minor_scale[minor_scale_index][0] + str(minor_scale[minor_scale_index][1])
	update_saved_notes()

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("special_attack"):
		if can_holy_sword:
			state_machine.transition_to("HolySword")
		if can_freeze:
			state_machine.transition_to("CastFreeze")
		if can_heal:
			state_machine.transition_to("Heal")
		if can_holy_wave:
			state_machine.transition_to("HolyWave")

func _on_hit(message) -> void:
	camera.apply_shake()
	update_saved_notes()

func add_note(victim_note) -> void:
	if saved_notes.size() == 7:
		saved_notes.erase(saved_notes[0])
	saved_notes.append(victim_note)

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
				
	check_for_heal_song()
	check_for_freeze_song()
	check_for_holy_wave_song()
	check_for_holy_sword_song()
				
func check_for_heal_song() -> void:
	tween1.kill()
	tween2.kill()
	tween3.kill()
	tween4.kill()
	tween5.kill()
	tween6.kill()
	$CanvasLayer/HealLabel1.visible = false
	$CanvasLayer/HealLabel2.visible = false
	$CanvasLayer/HealLabel3.visible = false
	$CanvasLayer/HealLabel4.visible = false
	$CanvasLayer/HealLabel5.visible = false
	if saved_notes.size() >= 3:
		if saved_notes[0] == "Do" and saved_notes[1] == "Fa" and saved_notes[2] == "So":
			$CanvasLayer/HealLabel1.visible = true
			can_heal = true
			aura.visible = true
			tween1 = create_tween()
			tween1.bind_node(self)
			tween1.set_loops()
			tween1.tween_property(saved_notes_hbox.get_children()[0].get_children()[0], "self_modulate", Color(4, 0.15, 0.27), 0.3)
			tween1.tween_property(saved_notes_hbox.get_children()[0].get_children()[0], "self_modulate", Color(1, 0.15, 0.27), 0.3)
			tween2 = create_tween()
			tween2.bind_node(self)
			tween2.set_loops()
			tween2.tween_property(saved_notes_hbox.get_children()[1].get_children()[0], "self_modulate", Color(0.2, 4, 0.25), 0.3)
			tween2.tween_property(saved_notes_hbox.get_children()[1].get_children()[0], "self_modulate", Color(0.2, 1, 0.25), 0.3)
			tween3 = create_tween()
			tween3.bind_node(self)
			tween3.set_loops()
			tween3.tween_property(saved_notes_hbox.get_children()[2].get_children()[0], "self_modulate", Color(0.1, 0.9, 6), 0.3)
			tween3.tween_property(saved_notes_hbox.get_children()[2].get_children()[0], "self_modulate", Color(0.1, 0.9, 1), 0.3)
	if saved_notes.size() >= 4:
		if saved_notes[1] == "Do" and saved_notes[2] == "Fa" and saved_notes[3] == "So":
			$CanvasLayer/HealLabel2.visible = true
			can_heal = true
			aura.visible = true
			tween2 = create_tween()
			tween2.bind_node(self)
			tween2.set_loops()
			tween2.tween_property(saved_notes_hbox.get_children()[1].get_children()[0], "self_modulate", Color(4, 0.15, 0.27), 0.3)
			tween2.tween_property(saved_notes_hbox.get_children()[1].get_children()[0], "self_modulate", Color(1, 0.15, 0.27), 0.3)
			tween3 = create_tween()
			tween3.set_loops()
			tween3.bind_node(self)
			tween3.tween_property(saved_notes_hbox.get_children()[2].get_children()[0], "self_modulate", Color(0.2, 4, 0.25), 0.3)
			tween3.tween_property(saved_notes_hbox.get_children()[2].get_children()[0], "self_modulate", Color(0.2, 1, 0.25), 0.3)
			var tween4 = create_tween()
			tween4.bind_node(self)
			tween4.set_loops()
			tween4.tween_property(saved_notes_hbox.get_children()[3].get_children()[0], "self_modulate", Color(0.1, 0.9, 6), 0.3)
			tween4.tween_property(saved_notes_hbox.get_children()[3].get_children()[0], "self_modulate", Color(0.1, 0.9, 1), 0.3)
	if saved_notes.size() >= 5:
		if saved_notes[2] == "Do" and saved_notes[3] == "Fa" and saved_notes[4] == "So":
			$CanvasLayer/HealLabel3.visible = true
			can_heal = true
			aura.visible = true
			tween3 = create_tween()
			tween3.bind_node(self)
			tween3.set_loops()
			tween3.tween_property(saved_notes_hbox.get_children()[2].get_children()[0], "self_modulate", Color(4, 0.15, 0.27), 0.3)
			tween3.tween_property(saved_notes_hbox.get_children()[2].get_children()[0], "self_modulate", Color(1, 0.15, 0.27), 0.3)
			tween4 = create_tween()
			tween4.bind_node(self)
			tween4.set_loops()
			tween4.tween_property(saved_notes_hbox.get_children()[3].get_children()[0], "self_modulate", Color(0.2, 4, 0.25), 0.3)
			tween4.tween_property(saved_notes_hbox.get_children()[3].get_children()[0], "self_modulate", Color(0.2, 1, 0.25), 0.3)
			tween5 = create_tween()
			tween5.bind_node(self)
			tween5.set_loops()
			tween5.tween_property(saved_notes_hbox.get_children()[4].get_children()[0], "self_modulate", Color(0.1, 0.9, 6), 0.3)
			tween5.tween_property(saved_notes_hbox.get_children()[4].get_children()[0], "self_modulate", Color(0.1, 0.9, 1), 0.3)
	if saved_notes.size() >= 6:
		if saved_notes[3] == "Do" and saved_notes[4] == "Fa" and saved_notes[5] == "So":
			$CanvasLayer/HealLabel4.visible = true
			can_heal = true
			aura.visible = true
			tween4 = create_tween()
			tween4.bind_node(self)
			tween4.set_loops()
			tween4.tween_property(saved_notes_hbox.get_children()[3].get_children()[0], "self_modulate", Color(4, 0.15, 0.27), 0.3)
			tween4.tween_property(saved_notes_hbox.get_children()[3].get_children()[0], "self_modulate", Color(1, 0.15, 0.27), 0.3)
			tween5 = create_tween()
			tween5.bind_node(self)
			tween5.set_loops()
			tween5.tween_property(saved_notes_hbox.get_children()[4].get_children()[0], "self_modulate", Color(0.2, 4, 0.25), 0.3)
			tween5.tween_property(saved_notes_hbox.get_children()[4].get_children()[0], "self_modulate", Color(0.2, 1, 0.25), 0.3)
			tween6 = create_tween()
			tween6.bind_node(self)
			tween6.set_loops()
			tween6.tween_property(saved_notes_hbox.get_children()[5].get_children()[0], "self_modulate", Color(0.1, 0.9, 6), 0.3)
			tween6.tween_property(saved_notes_hbox.get_children()[5].get_children()[0], "self_modulate", Color(0.1, 0.9, 1), 0.3)
	if saved_notes.size() >= 7:
		if saved_notes[4] == "Do" and saved_notes[5] == "Fa" and saved_notes[6] == "So":
			$CanvasLayer/HealLabel5.visible = true
			can_heal = true
			aura.visible = true
			tween5 = create_tween()
			tween5.bind_node(self)
			tween5.set_loops()
			tween5.tween_property(saved_notes_hbox.get_children()[4].get_children()[0], "self_modulate", Color(4, 0.15, 0.27), 0.3)
			tween5.tween_property(saved_notes_hbox.get_children()[4].get_children()[0], "self_modulate", Color(1, 0.15, 0.27), 0.3)
			tween6 = create_tween()
			tween6.bind_node(self)
			tween6.set_loops()
			tween6.tween_property(saved_notes_hbox.get_children()[5].get_children()[0], "self_modulate", Color(0.2, 4, 0.25), 0.3)
			tween6.tween_property(saved_notes_hbox.get_children()[5].get_children()[0], "self_modulate", Color(0.2, 1, 0.25), 0.3)
			tween7 = create_tween()
			tween7.bind_node(self)
			tween7.set_loops()
			tween7.tween_property(saved_notes_hbox.get_children()[6].get_children()[0], "self_modulate", Color(0.1, 0.9, 6), 0.3)
			tween7.tween_property(saved_notes_hbox.get_children()[6].get_children()[0], "self_modulate", Color(0.1, 0.9, 1), 0.3)

func check_for_freeze_song() -> void:
	if saved_notes.size() >= 3:
		if saved_notes[0] == "Ti" and saved_notes[1] == "La" and saved_notes[2] == "Fa":
			$CanvasLayer/FreezeLabel1.visible = true
			can_freeze = true
			var tween = create_tween()
			tween.bind_node(self)
			tween.set_loops()
			tween.tween_property(saved_notes_hbox.get_children()[0].get_children()[0], "self_modulate", Color(4, 0.15, 0.27), 0.3)
			tween.tween_property(saved_notes_hbox.get_children()[0].get_children()[0], "self_modulate", Color(1, 0.15, 0.27), 0.3)
	if saved_notes.size() >= 4:
		if saved_notes[1] == "Ti" and saved_notes[2] == "La" and saved_notes[3] == "Fa":
			$CanvasLayer/FreezeLabel2.visible = true
			can_freeze = true
	if saved_notes.size() >= 5:
		if saved_notes[2] == "Ti" and saved_notes[3] == "La" and saved_notes[4] == "Fa":
			$CanvasLayer/FreezeLabel3.visible = true
			can_freeze = true
	if saved_notes.size() >= 6:
		if saved_notes[3] == "Ti" and saved_notes[4] == "La" and saved_notes[5] == "Fa":
			$CanvasLayer/FreezeLabel4.visible = true
			can_freeze = true
	if saved_notes.size() >= 7:
		if saved_notes[4] == "Ti" and saved_notes[5] == "La" and saved_notes[6] == "Fa":
			$CanvasLayer/FreezeLabel5.visible = true
			can_freeze = true

func check_for_holy_wave_song() -> void:
	if saved_notes.size() >= 4:
		if saved_notes[0] == "La" and saved_notes[1] == "Mi" and saved_notes[2] == "Fa" and saved_notes[3] == "Re":
			can_holy_wave = true
	if saved_notes.size() >= 5:
		if saved_notes[1] == "La" and saved_notes[2] == "Mi" and saved_notes[3] == "Fa" and saved_notes[4] == "Re":
			can_holy_wave = true
	if saved_notes.size() >= 6:
		if saved_notes[2] == "La" and saved_notes[3] == "Mi" and saved_notes[4] == "Fa" and saved_notes[5] == "Re":
			can_holy_wave = true
	if saved_notes.size() >= 7:
		if saved_notes[3] == "La" and saved_notes[4] == "Mi" and saved_notes[5] == "Fa" and saved_notes[6] == "Re":
			can_holy_wave = true


func check_for_holy_sword_song() -> void:
	if saved_notes.size() >= 7:
		if saved_notes[0] == "Do" and saved_notes[1] == "Re" and saved_notes[2] == "Mi" and saved_notes[3] == "Fa" and saved_notes[4] == "So" and saved_notes[5] == "La" and saved_notes[6] == "Ti":
			can_holy_sword = true


func _physics_process(delta: float) -> void:
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
			camera.apply_shake()
			hp -= message
			$CanvasLayer/HealthBarControl.damage(message)
	if hp <= 0:
		state_machine.transition_to("Death")
	elif state_machine.state == $StateMachine/Block:
		$StateMachine/Block.block_hit()
	else:
		state_machine.transition_to("Hurt")
