extends Control

var is_paused = false setget set_is_paused

func _enter_tree():
	if self.name == "Death":
		WorldVariables.death_screen = self

func _unhandled_input(event):
	if event.is_action_pressed("pause") and self.name == "Pause" and not WorldVariables.death_screen.is_paused:
		self.is_paused = !is_paused

func set_is_paused(value):
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused

func _on_ResumeButton_pressed():
	self.is_paused = false

func _on_RetryButton_pressed():
	self.is_paused = false
	TurnOrder.enemy_group = []
	self.get_parent().get_parent().queue_free()
	WorldVariables.load_level(WorldVariables.current_level)

func _on_TitleScreenButton_pressed():
	self.is_paused = false
	TurnOrder.enemy_group = []
	self.get_parent().get_parent().queue_free()
	WorldVariables.load_level("TitleScreen")

func _on_QuitButton_pressed():
	get_tree().quit()
