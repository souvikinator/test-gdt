extends CharacterBody2D

const SPEED = 300.0
var target_position = null  # Stores the clicked position

func _physics_process(delta: float) -> void:
  # Move towards target position (if set)
	if target_position:
		# Calculate direction vector
		var direction = target_position - global_position
	
		# Check if close enough to target (optional, prevents jittering)
		if direction.length() <= 10:
			var pos = self.global_position + direction
			target_position = null  # Stop moving if close enough
			velocity = Vector2.ZERO  # Reset velocity on reaching target
			$Label.text = "{v}\n{p}".format({"v": velocity, "p":pos })
		else:
			# Normalize direction to avoid exceeding speed limit
			direction = direction.normalized()
			# Set velocity based on direction and speed
			velocity = direction * SPEED
			$Label.text = "{v}\n{p}".format({"v": velocity, "p":global_position })

		# Optionally rotate character to face target
		#look_at(target_position)

	# Move and handle collisions
	move_and_slide()

func _input(event):
	if event.is_action_pressed("click"):
		# Get clicked position in global coordinates
		target_position = get_global_mouse_position()
		print("CLICK TARGET: ", target_position)
