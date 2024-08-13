extends CharacterBody2D

@onready var sampler: SamplerInstrument = $"../SamplerInstrument"
@onready var sprite: Sprite2D = $Sprite2D

const SPEED := 500.0

const black := "000000"

const red := "d40036"
const orange := "db6603"
const yellow := "fca500"
const green := "00d541"
const blue := "0ba8da"
const indigo := "8e87ff"
const violet := "c438ff"

func _ready() -> void:
	sprite.modulate = black


func _physics_process(_delta: float) -> void:
	velocity = Vector2.ZERO
	if Input.get_axis("left", "right") > 0:
		velocity.x += 1 # right
	elif Input.get_axis("left", "right") < 0:
		velocity.x -= 1
		
	if Input.get_axis("down", "up") > 0:
		velocity.y -= 1
	if Input.get_axis("down", "up") < 0:
		velocity.y += 1
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * SPEED
	
	if Input.is_action_just_pressed("min_f"):
		sampler.play_note("C", 4)
		sprite.modulate = red
	if Input.is_action_just_pressed("min_g"):
		sampler.play_note("D", 4)
		sprite.modulate = orange
	if Input.is_action_just_pressed("min_h"):
		sampler.play_note("E", 4)
		sprite.modulate = yellow
	if Input.is_action_just_pressed("min_j"):
		sampler.play_note("F", 4)
		sprite.modulate = green
	if Input.is_action_just_pressed("min_k"):
		sampler.play_note("G", 4)
		sprite.modulate = blue
	if Input.is_action_just_pressed("min_l"):
		sampler.play_note("A", 4)
		sprite.modulate = indigo
	if Input.is_action_just_pressed("min_;"):
		sampler.play_note("B", 4)
		sprite.modulate = violet
	if Input.is_action_just_pressed("min_'"):
		sampler.play_note("C", 5)
		sprite.modulate = red
	move_and_slide()
