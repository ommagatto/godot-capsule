extends Control

# Check if mouse is moving
var mouse_is_moving: bool = false
# Mouse dragging start position
var mouse_dragging_start_position: Vector2i
# Play Funky Town
@onready var funky_town: AudioStreamPlayer = $AudioStreamPlayer
@onready var godot_capsule_model: MeshInstance3D = $PanelContainer/Capsule3D/GodotCapsuleModel



func _ready() -> void:
	# Play song
	funky_town.play()
	
	%Label.visible = true
	# We remove the borders so it looks like the sprite is floating
	get_window().borderless = true
	# Allow the window to be transparent
	get_window().transparent = true
	# Make the window's backgound transparent
	get_viewport().transparent_bg = true
	# Force the window always be on top of the screen
	get_window().always_on_top = true
	# Prevent resizing the window
	get_window().unresizable = false
	
	get_window().mouse_passthrough = false


func _process(delta: float) -> void:
	# Hange the model rotation
	godot_capsule_model.rotation.y += 1.0 * delta
	
	# Only execute the update logic if the mouse is currently being dragged
	if mouse_is_moving:
		# Get the current mouse position
		var mouse_moving_position: Vector2i = Vector2i(get_viewport().get_mouse_position())
		# Move the window by exactly how much the mouse traveled since clicked
		get_window().position += mouse_moving_position - mouse_dragging_start_position


## Dragging Logic for a window
# Connects the "gui_input" signal of the PanelContainer
# to handle mouse clicks and drags.
	%PanelContainer.gui_input.connect(func(event: InputEvent) -> void:
		# Only process Left Mouse Button events
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
			# If the mouse button was just pressed (not already being dragged),
			# record the current mouse position as the drag's starting point.
			if not mouse_is_moving:
				# Capture the click point as the reference for dragging
				mouse_dragging_start_position = get_viewport().get_mouse_position()
			# Track if the mouse button is currently held down (dragging)
			# event.is_pressed() returns true while the button is held down.
			mouse_is_moving = event.is_pressed()
		)


	# Right click Context menu
	%PanelContainer.gui_input.connect(func(event: InputEvent) -> void:
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			var tween = create_tween()
			tween.set_ease(Tween.EASE_OUT)
			tween.set_trans(Tween.TRANS_CIRC)
			tween.tween_property(%Label, "modulate:a", 0.0, 0.0)
			tween.tween_property(%Label, "modulate:a", 1.0, 1.5)
			tween.set_ease(Tween.EASE_IN)
			tween.set_trans(Tween.TRANS_CIRC)
			tween.tween_property(%Label, "modulate:a", 0.0, 1.5)
		)
