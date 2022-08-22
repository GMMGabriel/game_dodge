extends CanvasLayer

signal startGame

func updateScore(score):
	$ScoreLabel.text = str(score)

func showMessage(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()

func showGameOver():
	showMessage("Game Over")
	yield($MessageTimer, "timeout")
	$MessageLabel.text = "Dodge the Creeps"
	$MessageLabel.show()
	yield(get_tree().create_timer(1.0), "timeout")
	$Button.show()



func _on_Button_pressed():
	$Button.hide()
	emit_signal("startGame")

func _on_MessageTimer_timeout():
	$MessageLabel.hide()
