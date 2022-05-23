extends Area2D
signal hit


export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

func _ready():
	screen_size = get_viewport_rect().size
	# hide()

func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		# since we're adding a horizontal and a vertical movement, 
		# the player would move faster diagonally than if it just moved horizontally.
		# We can prevent that if we normalize the velocity
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		# $AnimatedSprite = get_node("AnimatedSprite")
		$AnimatedSprite.stop()
		
	# delta refers to the frame length, the amount of time that the previous frame took to complete
	# ensures that your movement will remain consistent
	# even if the frame rate changes.
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	# Choosing Animation
	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0


func _on_Player_body_entered(body):
	hide() # Player disappears after being hit.
	emit_signal("hit")
	# Must be deferred as we can't change physics properties on a physics callback.
	# we have to disable player's collision so we dont trigger "hit" again
	# set_deferred() tells Godot to wait to disable the shape until it's safe to do so.
	$CollisionShape2D.set_deferred("disabled", true)

# Resetet player when starting a new game
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
