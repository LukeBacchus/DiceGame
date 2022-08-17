extends Control


func _on_MainMenu_button_up():
	self.set_visible(false)
	get_parent().get_node("TitleScreen").set_visible(true)
