extends Node

export (PackedScene) var mobScene
var score = 0

func _ready():
	randomize()

func _process(delta):
	if Input.is_action_pressed("ui_select") and $HUD/Button.visible:
		$HUD._on_Button_pressed()

func newGame():
	score = 0
	$HUD.updateScore(score)
	
	get_tree().call_group("mobs", "queue_free")
	$Player.start($StartPosition.position)
	
	$StartTimer.start()
	$Music.play()
	
	$HUD.showMessage("Get ready...")
	
	yield($StartTimer, "timeout")
	$ScoreTimer.start()
	$MobTimer.start()

func gameOver():
	$Music.stop()
	$DeathSound.play()
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.showGameOver()

func _on_MobTimer_timeout():
	var mobSpawnLocation = $MobPath/MobSpawnLocation
	mobSpawnLocation.unit_offset = randf()

	var mob = mobScene.instance()
	add_child(mob)

	mob.position = mobSpawnLocation.position

	var direction = mobSpawnLocation.rotation + PI / 2
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction

	var velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = velocity.rotated(direction)


func _on_ScoreTimer_timeout():
	score += 1
	$HUD.updateScore(score)
