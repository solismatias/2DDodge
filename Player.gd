extends Area2D


export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

func _ready():
	screen_size = get_viewport_rect().size

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
