extends Control


func _ready() -> void:
	pass # Replace with function body.

# code for dragging to move staff

#var dragging = false
#var click_radius = 2000 # Size of the sprite.
#
#
#func _input(event):
	#if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		#if (event.position - position).length() < click_radius:
			## Start dragging if the click is on the sprite.
			#if not dragging and event.pressed:
				#dragging = true
		## Stop dragging if the button is released.
		#if dragging and not event.pressed:
			#dragging = false
#
	#if event is InputEventMouseMotion and dragging:
		## While dragging, move the sprite with the mouse.
		#position.y = event.position.y - 500
