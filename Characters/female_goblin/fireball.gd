extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hit_box: HitBox = $AnimatedSprite2D/HitBox
@onready var screen_notifier: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

const SPEED = 600.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	sprite.animation_finished.connect(_on_animation_finished)
	hit_box.hit_signal.connect(_on_fireball_hit)
	screen_notifier.screen_exited.connect(_on_exit_screen)
	hit_box.previously_hit_hurtboxes = []
	sprite.play("loop")

func _on_fireball_hit(msg) -> void:
	hit_box.process_mode = Node.PROCESS_MODE_DISABLED
	sprite.play("hit")

func _on_exit_screen():
	queue_free()
	
func _physics_process(delta: float) -> void:
	pass
	
func _on_animation_finished()-> void:
	#death of fireball
	if sprite.animation == "hit":
		queue_free()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move_and_slide()
