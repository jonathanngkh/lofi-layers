class_name Elementalist
extends CharacterBody2D

const SPEED = 500.0
const JUMP_VELOCITY = -1900.0
const BRAKING_SPEED = 400.0

@onready var note_preloads := {
	"Do": preload("res://utility/do_ui.tscn"),
	"Re": preload("res://utility/re_ui.tscn"),
	"Mi": preload("res://utility/mi_ui.tscn"),
	"Fa": preload("res://utility/fa_ui.tscn"),
	"So": preload("res://utility/so_ui.tscn"),
	"La": preload("res://utility/la_ui.tscn"),
	"Ti": preload("res://utility/ti_ui.tscn"),
}

@export var is_player_controlled := true
@export var debug_mode = false
@export var can_attack_while_blocking = true
@export var note_health := ["Do"]
@onready var note_health_number := note_health.size()
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hurt_box: Area2D = $HurtBox
@onready var hit_box: HitBox = $AnimatedSprite2D/HitBox
@onready var state_machine: StateMachine = $StateMachine
@onready var shadow: AnimatedSprite2D = $AnimatedSprite2D/ShadowAnimatedSprite2D

func _ready() -> void:
	hit_box.process_mode = Node.PROCESS_MODE_DISABLED
	
	for note in note_health:
		var note_ui_spawn = note_preloads[note].instantiate()
		for container in $HBoxContainer.get_children():
			if container.get_child_count() == 0:
				container.add_child(note_ui_spawn)
				break


func _physics_process(delta: float) -> void:
	if debug_mode:
		$Label.visible = true
		$Label.text = "state: " + $StateMachine.state.name
		$Label2.visible = true
		$Label2.text = "animation: " + sprite.animation
		$Label3.visible = true
		$Label3.text = "z: " + str(sprite.offset.y)
	else:
		$Label.visible = false
		$Label2.visible = false
		$Label3.visible = false


func receive_hit(message) -> void:
	#$HBoxContainer.get_children()[note_health_number - 1]
	#note_health.erase(note_health[-1])
	#if launch_or_not == "launch":
		#velocity.y += JUMP_VELOCITY * 1.3
	if state_machine.state == $StateMachine/Block:
		$StateMachine/Block.block_hit()
	else:
		state_machine.transition_to("Hurt")


func _unhandled_input(_event: InputEvent) -> void:
	pass