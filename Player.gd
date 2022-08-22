extends Area2D

signal hit

export var speed = 400.0
var screenSize = Vector2.ZERO
var playerFrameWidth = 108
var playerFrameHeight = 135
var playerWidthLimit = 0
var playerHeightLimit = 0

func _ready():
	hide()
	playerWidthLimit = (playerFrameWidth*$AnimatedSprite.transform.get_scale().x)/2
	playerHeightLimit = (playerFrameHeight*$AnimatedSprite.transform.get_scale().y)/2
	screenSize = get_viewport_rect().size

func _process(delta):
	var direction = Vector2.ZERO

	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1

	if Input.is_action_pressed("move_up"):
		direction.y -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1

	# AUMENTA A VELOCIDADE ENQUANTO O CTROL É PRESSIONADO
	if Input.is_action_pressed("increase_speed"):
		speed = 600.0
	if !Input.is_action_pressed("increase_speed"):
		speed = 400.0

	if direction.length() > 0:
		direction = direction.normalized()
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()

	position += direction * speed * delta
	position.x = clamp(position.x, playerWidthLimit, screenSize.x - (playerWidthLimit))
	position.y = clamp(position.y, playerHeightLimit, screenSize.y - (playerHeightLimit))

	if direction.x != 0:
		$AnimatedSprite.animation = "right"
		$AnimatedSprite.flip_h = direction.x < 0
		$AnimatedSprite.flip_v = false
	elif direction.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = direction.y > 0
		$AnimatedSprite.flip_h = false

func start(newPosition):
	reset()
	position = newPosition
	show()
	$CollisionShape2D.disabled = false

func reset():
	$AnimatedSprite.animation = "right"
	$AnimatedSprite.flip_h = false
	$AnimatedSprite.flip_v = false

func _on_Player_body_entered(body):
	hide()
	$CollisionShape2D.set_deferred("disabled", true)
	emit_signal("hit")
