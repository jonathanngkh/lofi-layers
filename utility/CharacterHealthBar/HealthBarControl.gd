extends Control

var PlayerMaxHealth = 20.0
var PlayerCurrentHealth = 20.0
var HealthBarPositionX = 50
var HealthBarPositionY = 50
var isHealing = false
var isDead = false

const HealthBarLeft = preload("res://utility/CharacterHealthBar/CharacterStatusBars/PlayerStats/HealthBar/HealthBarLeft.png")
const HealthBarCenter = preload("res://utility/CharacterHealthBar/CharacterStatusBars/PlayerStats/HealthBar/HealthBarCenter.png")
const HealthBarRight = preload("res://utility/CharacterHealthBar/CharacterStatusBars/PlayerStats/HealthBar/HealthBarRight.png")
const HealthBarFrameLeft = preload("res://utility/CharacterHealthBar/CharacterStatusBars/PlayerStats/HealthBar/HealthBarFrameLeft.png")
const HealthBarFrameCenter = preload("res://utility/CharacterHealthBar/CharacterStatusBars/PlayerStats/HealthBar/HealthBarFrameCenter.png")
const HealthBarFrameRight = preload("res://utility/CharacterHealthBar/CharacterStatusBars/PlayerStats/HealthBar/HealthBarFrameRight.png")
const HealthBarLaggingLeft = preload("res://utility/CharacterHealthBar/CharacterStatusBars/PlayerStats/HealthBar/HealthLaggingLeft.png")
const HealthBarLaggingCenter = preload("res://utility/CharacterHealthBar/CharacterStatusBars/PlayerStats/HealthBar/HealthLaggingCenter.png")
const HealthBarLaggingRight = preload("res://utility/CharacterHealthBar/CharacterStatusBars/PlayerStats/HealthBar/HealthLaggingRight.png")
const HealthBarLaggingRecoveryLeft = preload("res://utility/CharacterHealthBar/CharacterStatusBars/PlayerStats/HealthBar/RecoveryBarLeft.png")
const HealthBarLaggingRecoveryCenter = preload("res://utility/CharacterHealthBar/CharacterStatusBars/PlayerStats/HealthBar/RecoveryBarCenter.png")
const HealthBarLaggingRecoveryRight = preload("res://utility/CharacterHealthBar/CharacterStatusBars/PlayerStats/HealthBar/RecoveryBarRight.png")

@onready var HPEdgeAnim = $HPEdgeAnimated
@onready var HPBloodLossSplatter = $HPBloodlossSplatter
@onready var HealthBar = $TextureHealthBar
@onready var LaggingBar = $TextureHealthLaggingBar
@onready var CurrentHealthText = $CurrentHealthText
@onready var MaxHealthText = $MaxHealthText
@onready var Portrait = $Portrait

func _ready():
	HPEdgeAnim.hide()
	HPEdgeAnim.position.y = HealthBarPositionY + 9
	HPEdgeAnim.animation_finished.connect(_animation_finished)
	
	HPBloodLossSplatter.hide()
	HPBloodLossSplatter.position.y = HealthBarPositionY + 12
	HPBloodLossSplatter.animation_finished.connect(_animation_finished)
	
	Portrait.show()
	Portrait.position = Vector2(HealthBarPositionX-20,HealthBarPositionY+8)
	Portrait.frame = 0
	Portrait.pause()
	
	CurrentHealthText.position = Vector2(HealthBarPositionX-5,HealthBarPositionY-13)
	CurrentHealthText.text = "%s /" % PlayerCurrentHealth
	MaxHealthText.position = Vector2(HealthBarPositionX+15,HealthBarPositionY-13)
	MaxHealthText.text = "%s" % PlayerMaxHealth 
	
	HealthBar.value = PlayerCurrentHealth/PlayerMaxHealth * 100	
	HealthBar.size.x = PlayerMaxHealth * 18
	HealthBar.size.y = 18
	LaggingBar.value = PlayerCurrentHealth/PlayerMaxHealth * 100
	LaggingBar.size.x = PlayerMaxHealth * 18
	LaggingBar.size.y = 18
	
	for i in range(PlayerMaxHealth): 
		var HealthBarSegment = TextureProgressBar.new()
		HealthBarSegment.fill_mode = 0
		HealthBarSegment.size = Vector2(18,18)
		HealthBarSegment.position.y = HealthBarPositionY
		HealthBarSegment.min_value = i * (100/PlayerMaxHealth)
		HealthBarSegment.max_value = (i+1) * 100/PlayerMaxHealth
		HealthBarSegment.value = HealthBar.value
		
		var HealthLaggingSegment = TextureProgressBar.new()
		HealthLaggingSegment.fill_mode = 0
		HealthLaggingSegment.size = Vector2(18,18)
		HealthLaggingSegment.position.y = HealthBarPositionY
		HealthLaggingSegment.min_value = i * (100/PlayerMaxHealth)
		HealthLaggingSegment.max_value = (i+1) * (100/PlayerMaxHealth)
		HealthLaggingSegment.value = LaggingBar.value
		
		if i == 0:
			HealthBarSegment.texture_progress = HealthBarLeft
			HealthBarSegment.position.x = HealthBarPositionX
			
			HealthLaggingSegment.texture_under = HealthBarFrameLeft
			HealthLaggingSegment.texture_progress = HealthBarLaggingLeft
			HealthLaggingSegment.position.x = HealthBarPositionX
		elif i == PlayerMaxHealth-1:
			HealthBarSegment.texture_progress = HealthBarRight
			HealthBarSegment.position.x = HealthBarPositionX + 4 + i * 15
			
			HealthLaggingSegment.texture_under = HealthBarFrameRight
			HealthLaggingSegment.texture_progress = HealthBarLaggingRight
			HealthLaggingSegment.position.x = HealthBarPositionX + 4 + i * 15
		else:
			HealthBarSegment.texture_progress = HealthBarCenter
			HealthBarSegment.position.x = HealthBarPositionX + 2 + i * 15
			
			HealthLaggingSegment.texture_under = HealthBarFrameCenter
			HealthLaggingSegment.texture_progress = HealthBarLaggingCenter
			HealthLaggingSegment.position.x = HealthBarPositionX + 2 + i * 15
			
		LaggingBar.add_child(HealthLaggingSegment)
		HealthBar.add_child(HealthBarSegment)
		updateEdgeAnimations()

func _process(_delta):
	pass

func _on_Timer_timeout():
	if isHealing:
		if HealthBar.value < LaggingBar.value :
			HealthBar.value += (1/PlayerMaxHealth)*10
		else:
			updateEdgeAnimations()
			isHealing = false
		var HealthBarSegmentsArray = HealthBar.get_children()
		for i in HealthBarSegmentsArray:
			i.value = HealthBar.value
		if HealthBar.value < ((PlayerMaxHealth-0.5)/PlayerMaxHealth)*100:	
			HPEdgeAnim.play("RecoverHP3")
			HPEdgeAnim.position.x = HealthBarPositionX +6+ ((HealthBar.value+1.5)/100)*(PlayerMaxHealth*15)
			print(HealthBar.value)
			print(HPEdgeAnim.position.x)
		else: 
			HPEdgeAnim.play("RecoverRightEnd")
			HPEdgeAnim.position.x = HealthBarPositionX + 20 + ((PlayerCurrentHealth-1)*15)
		
			
			
	else:
		updateEdgeAnimations()
		if LaggingBar.value > HealthBar.value :
			LaggingBar.value -= 1
		var HealthBarLaggingSegmentsArray = LaggingBar.get_children()
		for i in HealthBarLaggingSegmentsArray:
			i.value = LaggingBar.value	

	
func _input(_event:InputEvent) -> void:
	pass
	#if event.is_action_pressed("ui_accept"):
		#damage(1)
	#if event.is_action_pressed("ui_down"):
		#heal(3)
		
func damage(damAmt):
	isHealing = false
	PlayerCurrentHealth -= damAmt
	PlayerCurrentHealth = max(PlayerCurrentHealth,0)
	CurrentHealthText.text = "%s /" % PlayerCurrentHealth
	HealthBar.value = PlayerCurrentHealth/PlayerMaxHealth * 100
	HPBloodLossSplatter.show()
	HPBloodLossSplatter.position.x = HealthBarPositionX + 24 + ((PlayerCurrentHealth-1)*15)
	HPBloodLossSplatter.play("BloodSplatter")
	updateEdgeAnimations()
	var HealthBarSegmentsArray = HealthBar.get_children()
	for i in HealthBarSegmentsArray:
		i.value = HealthBar.value
	if PlayerCurrentHealth <= 0:
		isDead = true
		Portrait.play("PortraitBreak")
	var HealthBarLaggingSegmentsArray = LaggingBar.get_children()
	for i in HealthBarLaggingSegmentsArray:
		if i == HealthBarLaggingSegmentsArray[0]:
			i.texture_progress = HealthBarLaggingLeft
		elif i == HealthBarLaggingSegmentsArray[-1]:
			i.texture_progress = HealthBarLaggingRight
		else:
			i.texture_progress = HealthBarLaggingCenter
	

func updateEdgeAnimations():
	if HealthBar.value <= 0 or HealthBar.value >=100:
		HPEdgeAnim.hide()
	else:
		HPEdgeAnim.show()
		HPEdgeAnim.position.x = HealthBarPositionX + 24 + ((PlayerCurrentHealth-1)*15)
		HPEdgeAnim.play("LossHP2")

func heal(healAmt):
	if not isDead:
		isHealing = true
		PlayerCurrentHealth += healAmt
		PlayerCurrentHealth = min(PlayerCurrentHealth,PlayerMaxHealth)
		CurrentHealthText.text = "%s /" % PlayerCurrentHealth
		LaggingBar.value = PlayerCurrentHealth/PlayerMaxHealth * 100
		var HealthBarLaggingSegmentsArray = LaggingBar.get_children()
		for i in HealthBarLaggingSegmentsArray:
			if i == HealthBarLaggingSegmentsArray[0]:
				i.texture_progress = HealthBarLaggingRecoveryLeft
			elif i == HealthBarLaggingSegmentsArray[-1]:
				i.texture_progress = HealthBarLaggingRecoveryRight
			else:
				i.texture_progress = HealthBarLaggingRecoveryCenter
			i.value = LaggingBar.value	


func _animation_finished():
	if HPEdgeAnim.animation == "LossHP2" or "RecoverHP3":
		if HealthBar.value <= 0:
			HPEdgeAnim.hide()
		else: 
			HPEdgeAnim.play("HPEdgeIdle")

	
