class_name TankGoblin
extends CharacterBody2D

@export var damage := 2
@export var rest_duration := 3.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hit_box: Area2D = $AnimatedSprite2D/HitBox
@onready var hurt_box: Area2D = $HurtBox
@onready var state_machine: StateMachine = $StateMachine
@onready var move_detection: Area2D = $AnimatedSprite2D/MoveRange
@onready var attack_detection: Area2D = $AnimatedSprite2D/AttackRange
@onready var rest_timer: Timer = $RestTimer
@export var is_played_controlled:= false
@export var note_health := ["Do"]

const SPEED = 100.0
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

#tank_goblin has no Hurt State, so hurt sounds are just used here
@onready var hurt_sounds = [
	preload("res://Characters/tank_goblin/sounds/sfx_enemy_tankgoblin_hurt_01.wav"),
	preload("res://Characters/tank_goblin/sounds/sfx_enemy_tankgoblin_hurt_02.wav"),
	preload("res://Characters/tank_goblin/sounds/sfx_enemy_tankgoblin_hurt_03.wav"),
	preload("res://Characters/tank_goblin/sounds/sfx_enemy_tankgoblin_hurt_04.wav"),

]

@onready var enemy_impact_sounds = [
	preload("res://Characters/sfx/sfx_enemy_impact_01 [Draft 2].wav"),
	preload("res://Characters/sfx/sfx_enemy_impact_02 [Draft 2].wav"),
	preload("res://Characters/sfx/sfx_enemy_impact_03 [Draft 2].wav")
]

var player_chase := false
var is_resting := false

func _ready() -> void:
	hit_box.process_mode = Node.PROCESS_MODE_DISABLED
	for note in note_health:
		var note_ui_spawn = note_preloads[note].instantiate()
		for container in $HBoxContainer.get_children():
			if container.get_child_count() == 0:
				container.add_child(note_ui_spawn)
				break
	rest_timer.timeout.connect(_on_timer_timeout)
	
func _on_timer_timeout():
	is_resting = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()

func receive_hit(message) -> void:
	if message == "holy_sword":
		#print('frozen')
		#state_machine.transition_to("Freeze")
	#elif message == "holy_sword":
		state_machine.transition_to("Death")
	else:
		# tank_Goblin doesnt get hurt
		sprite.set_speed_scale(0.1)
		var tween: Tween = create_tween()
		$AudioStreamPlayer2D_Impact.stream = enemy_impact_sounds.pick_random()
		$AudioStreamPlayer2D_Impact.play()
		$AudioStreamPlayer2D_Hurt.stream = hurt_sounds.pick_random()
		$AudioStreamPlayer2D_Hurt.play()
		await tween.tween_property(sprite, "modulate:v", 1, 0.3).from(5).finished
		sprite.set_speed_scale(1)
		
