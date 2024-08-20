class_name Dummy
extends CharacterBody2D

@export var random_notes_mode := false
@export var note_health := ["Do"]
var note_rotate_dict := {
	"Do": 0,
	"Re": 1,
	"Mi": 2,
	"Fa": 3,
	"So": 4,
	"La": 5,
	"Ti": 6,
}
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var state_machine: StateMachine = $StateMachine
@onready var solfege_container: Control = $SolfegeWheel/SolfegeContainer


func _ready() -> void:
	for i in range(note_rotate_dict[note_health[0]]):
		for solfege in solfege_container.get_children():
			solfege.solfege_forward()
	#for note in note_health:
		#var note_ui_spawn = note_preloads[note].instantiate()
		#for container in $HBoxContainer.get_children():
			#if container.get_child_count() == 0:
				#container.add_child(note_ui_spawn)
				#break


func _physics_process(delta: float) -> void:
	for solfege_note in solfege_container.get_children():
		if solfege_note.position == Vector2(-11, -45):
			note_health[0] = solfege_note.name.left(2)
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta


	move_and_slide()


func receive_hit(message) -> void:
	if message == "freeze":
		state_machine.transition_to("Freeze")
	elif message == "holy_sword":
		state_machine.transition_to("Death")
	else:
		state_machine.transition_to("Hurt")
