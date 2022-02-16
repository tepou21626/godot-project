extends CanvasLayer


signal start_game


# Images assets
var full_heart = preload("res://art/hud_heartFull.png")
var empty_heart = preload("res://art/hud_heartEmpty.png")


# Method called when application is launched.
func _ready():
	$ReviewWindow.update_reviews_text_box()


# Method that updates score count.
# Source: https://www.youtube.com/watch?v=WEt2JHEe-do
func update_score(score):
	$ScoreLabel.text = str(score)
	
	
# Method that displays message.
# Source: https://www.youtube.com/watch?v=WEt2JHEe-do
func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()
	
	
# Method that displays game over screen.
# Source: https://www.youtube.com/watch?v=WEt2JHEe-do
func show_game_over():
	show_message("Game Over")
	yield($MessageTimer, "timeout")
	$MessageLabel.text = "Dodge the creeps!"
	$MessageLabel.show()
	yield(get_tree().create_timer(1.0), "timeout")
	$HeartContainer.hide()
	$Button.show()
	$ReviewButton.show()
	

# Method called when "play" button is pressed.
# Source: https://www.youtube.com/watch?v=WEt2JHEe-do
func _on_Button_pressed():
	$Button.hide()
	$ReviewButton.hide()
	draw_lives(3)
	$HeartContainer.show()
	emit_signal("start_game")


# Method called when message timer is finished.
# Source: https://www.youtube.com/watch?v=WEt2JHEe-do
func _on_MessageTimer_timeout():
	$MessageLabel.hide()



# Method that displays the amount of hearts.
func draw_lives(lives):
	var total_hearts = $HeartContainer.get_child_count()
	for i in total_hearts:
		if i < lives:
			$HeartContainer.get_child(i).texture = full_heart
		else:
			$HeartContainer.get_child(i).texture = empty_heart


# Method that shows reviews window and hides game window.
func _on_ReviewButton_pressed():
	$ScoreLabel.hide()
	$MessageLabel.hide()
	$Button.hide()
	$ReviewButton.hide()
	$ReviewWindow.show()
	$HeartContainer.hide()


# Method that shows games window and hides reviews window.
func _on_BackButton_pressed():
	$ScoreLabel.show()
	$MessageLabel.show()
	$Button.show()
	$ReviewButton.show()
	$ReviewWindow.hide()

